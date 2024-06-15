//
//  GetImagesUseCase.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Moya
import Factory
import Combine
import GalleryApp_Core
import GalleryApp_Models

// MARK: - GetImagesUseCase
protocol GetImagesUseCase: UseCase
where Input == Int,
      SuccessType == [GalleryApp_Models.Image],
      FailureType == MoyaError {}

// MARK: - DefaultGetImagesUseCase
final class DefaultGetImagesUseCase {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.galleryFeaturesRepository)
    private var galleryFeaturesRepository: GalleryFeaturesRepository
}

// MARK: - GetImagesUseCase
extension DefaultGetImagesUseCase: GetImagesUseCase {
    func execute(request: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        galleryFeaturesRepository.getImages(requestDTO: request)
    }
}
