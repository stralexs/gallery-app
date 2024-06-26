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
protocol ImageDescriptionViewModelInput: ViewModelInput {
    func setImages(_ images: [GalleryApp_Models.Image])
    func getMoreImages()
    func toggleIsFavorite(_ currentImage: Int)
    func retryAction(_ currentImage: Int)
}

// MARK: - Output
protocol ImageDescriptionViewModelOutput: ViewModelOutput {
    var output: [GalleryApp_Models.Image] { get }
    var isErrorOccurred: Bool { get }
}

// MARK: - ImageDescriptionViewModel
typealias ImageDescriptionViewModel = Subscriptionable & ImageDescriptionViewModelInput & ImageDescriptionViewModelOutput & ObservableObject

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
    @Published private(set) var output: [Image] = []
    @Published private(set) var isErrorOccurred: Bool = false
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var pagesCounter: Int = .zero
    
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
        getUserFavoriteImagesUseCase
            .execute(request: ())
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    isInternalErrorOccurredSubject.send(true)
                }
            } receiveValue: { [unowned self] favorits in
                let ids = favorits.map { $0.id }
                let toggledImages = images.map { image in
                    var toggledImage = image
                    if ids.contains(image.id) && !image.isFavorite {
                        toggledImage.toggleIsFavorite()
                    }
                    return toggledImage
                }
                output = toggledImages
                pagesCounter = toggledImages.count / 30
            }
            .store(in: &subscriptions)
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
                self.output.append(contentsOf: images)
            }
            .store(in: &subscriptions)
    }
    
    func toggleIsFavorite(_ currentImage: Int) {
        let image = output[currentImage]
        let isFavorite = output[currentImage].isFavorite
        if !isFavorite {
            addToFavoritesUseCase
                .execute(request: image)
                .sink { [unowned self] completion in
                    switch completion {
                    case .finished:
                        output[currentImage].toggleIsFavorite()
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
                        output[currentImage].toggleIsFavorite()
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
            isNetworkErrorOccurredSubject.send(false)
        }
        if isInternalErrorOccurredSubject.value {
            toggleIsFavorite(currentImage)
            isInternalErrorOccurredSubject.send(false)
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
