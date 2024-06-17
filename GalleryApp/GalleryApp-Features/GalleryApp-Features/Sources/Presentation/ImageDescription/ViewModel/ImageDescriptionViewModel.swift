//
//  ImageDescriptionViewModel.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 15.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - Input
public protocol ImageDescriptionViewModelInput: ViewModelInput {
    func setImages(_ images: [GalleryApp_Models.Image])
    func getMoreImages()
    func toggleIsFavorite(_ currentImage: Int)
    func retryAction(_ currentImage: Int)
}

// MARK: - Output
public protocol ImageDescriptionViewModelOutput: ViewModelOutput {
    var images: [GalleryApp_Models.Image] { get }
    var isErrorOccurred: Bool { get }
}

// MARK: - ImageDescriptionViewModel
public typealias ImageDescriptionViewModel = Subscriptionable & ImageDescriptionViewModelInput & ImageDescriptionViewModelOutput & ObservableObject

// MARK: - DefaultImageDescriptionViewModel
final class DefaultImageDescriptionViewModel: ImageDescriptionViewModel {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.getImagesUseCase)
    private var getImagesUseCase: any GetImagesUseCase
    
    @LazyInjected(\.galleryFeaturesContainer.getUserFavoriteImagesUseCase)
    private var getUserFavoriteImagesUseCase: any GetUserFavoriteImagesUseCase
    
    @LazyInjected(\.galleryFeaturesContainer.addToFavoritesUseCase)
    private var addToFavoritesUseCase: any AddToFavoritesUseCase
    
    @LazyInjected(\.galleryFeaturesContainer.removeFromFavoritesUseCase)
    private var removeFromFavoritesUseCase: any RemoveFromFavoritesUseCase
    
    // MARK: Properties
    @Published private(set) var images: [Image] = []
    @Published private(set) var isErrorOccurred: Bool = false
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var pagesCounter: Int = 0
    
    // MARK: Publishers
    private let isNetworkErrorOccurredSubject = CurrentValueSubject<Bool, Never>(false)
    private let isInternalErrorOccurredSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Initializer
    init() {
        setUpPublishers()
    }
}

// MARK: - Input
extension DefaultImageDescriptionViewModel {
    func setImages(_ images: [GalleryApp_Models.Image]) {
        self.images = images
        pagesCounter = images.count / 30
    }
    
    func getMoreImages() {
        pagesCounter += 1
        getImagesUseCase
            .execute(request: pagesCounter)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    isNetworkErrorOccurredSubject.send(true)
                }
            } receiveValue: { [unowned self] images in
                self.images.append(contentsOf: images)
            }
            .store(in: &subscriptions)
    }
    
    func toggleIsFavorite(_ currentImage: Int) {
        let image = images[currentImage]
        let isFavorite = images[currentImage].isFavorite
        if !isFavorite {
            addToFavoritesUseCase
                .execute(request: image)
                .sink { [unowned self] completion in
                    switch completion {
                    case .finished:
                        images[currentImage].toggleIsFavorite()
                    case .failure:
                        isInternalErrorOccurredSubject.send(true)
                    }
                } receiveValue: { _ in }
                .store(in: &subscriptions)
        } else {
            getUserFavoriteImagesUseCase
                .execute(request: ())
                .flatMap { [unowned self] favorites -> AnyPublisher<Void, CoreDataError> in
                    guard let imageToDelete = favorites.first(where: { $0.id == image.id }) else {
                        return Fail(error: CoreDataError.deleteExecutionError).eraseToAnyPublisher()
                    }
                    return removeFromFavoritesUseCase.execute(request: imageToDelete)
                }
                .sink { [unowned self] completion in
                    switch completion {
                    case .finished:
                        images[currentImage].toggleIsFavorite()
                    case .failure:
                        isInternalErrorOccurredSubject.send(true)
                    }
                } receiveValue: { _ in }
                .store(in: &subscriptions)
        }
    }
    
    func retryAction(_ currentImage: Int) {
        if isNetworkErrorOccurredSubject.value {
            pagesCounter -= 1
            getMoreImages()
        }
        if isInternalErrorOccurredSubject.value {
            toggleIsFavorite(currentImage)
        }
    }
}

// MARK: - Private
private extension DefaultImageDescriptionViewModel {
    func setUpPublishers() {
        Publishers.CombineLatest(isNetworkErrorOccurredSubject, isInternalErrorOccurredSubject)
            .map { $0 || $1 }
            .assign(to: \.isErrorOccurred, on: self)
            .store(in: &subscriptions)
    }
}
