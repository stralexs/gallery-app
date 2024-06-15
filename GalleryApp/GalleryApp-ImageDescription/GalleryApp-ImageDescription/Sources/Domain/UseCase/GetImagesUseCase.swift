//
//  GetImagesUseCase.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
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
    @LazyInjected(\.imageDescriptionContainer.imageDescriptionRepository)
    private var imageDescriptionRepository: ImageDescriptionRepository
}

// MARK: - GetImagesUseCase
extension DefaultGetImagesUseCase: GetImagesUseCase {
    func execute(request: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        imageDescriptionRepository.getImages(requestDTO: request)
    }
}
