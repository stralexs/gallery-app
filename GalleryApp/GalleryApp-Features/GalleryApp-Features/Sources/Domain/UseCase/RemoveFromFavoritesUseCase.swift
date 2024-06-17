//
//  RemoveFromFavoritesUseCase.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 17.06.24.
//

import Factory
import Combine
import GalleryApp_Core
import GalleryApp_Models

// MARK: - RemoveFromFavoritesUseCase
protocol RemoveFromFavoritesUseCase: UseCase
where Input == FavoriteImage,
      SuccessType == Void,
      FailureType == CoreDataError {}

// MARK: - DefaultRemoveFromFavoritesUseCase
final class DefaultRemoveFromFavoritesUseCase {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.galleryFeaturesRepository)
    private var galleryFeaturesRepository: GalleryFeaturesRepository
}

// MARK: - RemoveFromFavoritesUseCase
extension DefaultRemoveFromFavoritesUseCase: RemoveFromFavoritesUseCase {
    func execute(request: FavoriteImage) -> AnyPublisher<Void, CoreDataError> {
        galleryFeaturesRepository.removeFromFavorites(requestDTO: request)
    }
}
