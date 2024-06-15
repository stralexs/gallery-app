//
//  DefaultImagesListRepository.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory
import Combine
import Moya
import GalleryApp_Models

// MARK: - DefaultImagesListRepository
final class DefaultImagesListRepository {
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.imagesListDataSource)
    private var imagesListDataSource: ImagesListDataSource
    
    @LazyInjected(\.imagesListContainer.getImagesDTOToDomainMapper)
    private var getImagesDTOToDomainMapper: GetImagesDTOToDomainMapper
}

// MARK: - ImagesListRepository
extension DefaultImagesListRepository: ImagesListRepository {
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        imagesListDataSource.getImages(requestDTO: requestDTO)
            .map { [weak self] imagesDTO in
                guard let self else { return [] }
                return self.getImagesDTOToDomainMapper.mapModel(imagesDTO)
            }
            .eraseToAnyPublisher()
    }
}
