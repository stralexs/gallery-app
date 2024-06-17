//
//  GetUserFavoriteImagesUseCase.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 16.06.24.
//

import Factory
import Combine
import GalleryApp_Core
import GalleryApp_Models

// MARK: - GetUserFavoriteImagesUseCase
protocol GetUserFavoriteImagesUseCase: UseCase
where Input == Any?,
      SuccessType == [FavoriteImage],
      FailureType == CoreDataError {}

// MARK: - DefaultGetUserFavoriteImagesUseCase
final class DefaultGetUserFavoriteImagesUseCase {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.galleryFeaturesRepository)
    private var galleryFeaturesRepository: GalleryFeaturesRepository
}

// MARK: - GetUserFavoriteImagesUseCase
extension DefaultGetUserFavoriteImagesUseCase: GetUserFavoriteImagesUseCase {
    func execute(request: Any?) -> AnyPublisher<[FavoriteImage], CoreDataError> {
        galleryFeaturesRepository.getFavorites()
    }
}
