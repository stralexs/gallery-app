//
//  DefaultImageDescriptionRepository.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import Factory
import Combine
import Moya
import GalleryApp_Models

// MARK: - DefaultImageDescriptionRepository
final class DefaultImageDescriptionRepository {
    
    // MARK: Injected
    @LazyInjected(\.imageDescriptionContainer.imageDescriptionDataSource)
    private var imageDescriptionDataSource: ImageDescriptionDataSource
    
    @LazyInjected(\.imageDescriptionContainer.getImagesDTOToDomainMapper)
    private var getImagesDTOToDomainMapper: GetImagesDTOToDomainMapper
}

// MARK: - ImageDescriptionRepository
extension DefaultImageDescriptionRepository: ImageDescriptionRepository {
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        imageDescriptionDataSource.getImages(requestDTO: requestDTO)
            .map { [weak self] imagesDTO in
                guard let self else { return [] }
                return self.getImagesDTOToDomainMapper.mapModel(imagesDTO)
            }
            .eraseToAnyPublisher()
    }
}

