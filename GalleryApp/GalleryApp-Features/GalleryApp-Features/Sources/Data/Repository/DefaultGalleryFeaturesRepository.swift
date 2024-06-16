//
//  DefaultGalleryFeaturesRepository.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory
import Combine
import Moya
import GalleryApp_Models

// MARK: - DefaultGalleryFeaturesRepository
final class DefaultGalleryFeaturesRepository {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.galleryFeaturesDataSource)
    private var galleryFeaturesDataSource: GalleryFeaturesDataSource
    
    @LazyInjected(\.galleryFeaturesContainer.getImagesDTOToDomainMapper)
    private var getImagesDTOToDomainMapper: GetImagesDTOToDomainMapper
}

// MARK: - GalleryFeaturesRepository
extension DefaultGalleryFeaturesRepository: GalleryFeaturesRepository {
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        galleryFeaturesDataSource.getImages(requestDTO: requestDTO)
            .map { [weak self] imagesDTO in
                guard let self else { return [] }
                return self.getImagesDTOToDomainMapper.mapModel(imagesDTO)
            }
            .eraseToAnyPublisher()
    }
    
    func getFavorites() -> AnyPublisher<[GalleryApp_Models.Image], CoreDataError> {
        galleryFeaturesDataSource.getFavorites()
    }
}
