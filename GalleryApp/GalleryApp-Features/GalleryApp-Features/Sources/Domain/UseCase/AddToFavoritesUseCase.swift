//
//  AddToFavoritesUseCase.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 17.06.24.
//

import Factory
import Combine
import GalleryApp_Core
import GalleryApp_Models

// MARK: - AddToFavoritesUseCase
protocol AddToFavoritesUseCase: UseCase
where Input == GalleryApp_Models.Image,
      SuccessType == Void,
      FailureType == CoreDataError {}

// MARK: - DefaultAddToFavoritesUseCase
final class DefaultAddToFavoritesUseCase {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.galleryFeaturesRepository)
    private var galleryFeaturesRepository: GalleryFeaturesRepository
}

// MARK: - AddToFavoritesUseCase
extension DefaultAddToFavoritesUseCase: AddToFavoritesUseCase {
    func execute(request: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError> {
        galleryFeaturesRepository.addToFavorites(requestDTO: request)
    }
}
