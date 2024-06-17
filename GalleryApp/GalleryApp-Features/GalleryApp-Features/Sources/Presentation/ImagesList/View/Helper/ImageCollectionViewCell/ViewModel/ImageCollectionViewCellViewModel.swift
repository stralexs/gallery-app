//
//  ImageCollectionViewCellViewModel.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 16.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models
import GalleryApp_CoreData

// MARK: - Input
public protocol ImageCollectionViewCellViewModelInput: ViewModelInput {
    func set(_ image: GalleryApp_Models.Image)
    func toggleIsFavorite()
}

// MARK: - Output
public protocol ImageCollectionViewCellViewModelOutput: ViewModelOutput {
    var image: AnyPublisher<GalleryApp_Models.Image, CoreDataError> { get }
}

// MARK: - ImageCollectionViewCellViewModel
public typealias ImageCollectionViewCellViewModel = Subscriptionable & ImageCollectionViewCellViewModelInput & ImageCollectionViewCellViewModelOutput


// MARK: - DefaultImageCollectionViewCellViewModel
final class DefaultImageCollectionViewCellViewModel: ImageCollectionViewCellViewModel {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.getUserFavoriteImagesUseCase)
    private var getUserFavoriteImagesUseCase: any GetUserFavoriteImagesUseCase
    
    @LazyInjected(\.galleryFeaturesContainer.addToFavoritesUseCase)
    private var addToFavoritesUseCase: any AddToFavoritesUseCase
    
    @LazyInjected(\.galleryFeaturesContainer.removeFromFavoritesUseCase)
    private var removeFromFavoritesUseCase: any RemoveFromFavoritesUseCase
    
    // MARK: Publishers
    private let imageSubject = CurrentValueSubject<GalleryApp_Models.Image?, CoreDataError>(nil)
    var image: AnyPublisher<GalleryApp_Models.Image, CoreDataError> {
        imageSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
}

// MARK: - Input
extension DefaultImageCollectionViewCellViewModel {
    func set(_ image: GalleryApp_Models.Image) {
        imageSubject.send(image)
    }
    
    func toggleIsFavorite() {
        guard var image = imageSubject.value else { return }
        let isFavorite = image.isFavorite
        if !isFavorite {
            addToFavoritesUseCase
                .execute(request: image)
                .sink { [unowned self] completion in
                    switch completion {
                    case .finished:
                        image.toggleIsFavorite()
                        imageSubject.send(image)
                    case .failure(let error):
                        imageSubject.send(completion: .failure(error))
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
                        image.toggleIsFavorite()
                        imageSubject.send(image)
                    case .failure(let error):
                        imageSubject.send(completion: .failure(error))
                    }
                } receiveValue: { _ in }
                .store(in: &subscriptions)
        }
    }
}
