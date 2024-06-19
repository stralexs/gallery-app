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
import GalleryApp_CoreData

// MARK: - DefaultGalleryFeaturesRepository
final class DefaultGalleryFeaturesRepository {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.galleryFeaturesDataSource)
    private var galleryFeaturesDataSource: GalleryFeaturesDataSource
    
    @LazyInjected(\.galleryFeaturesContainer.getImagesDTOToDomainMapper)
    private var getImagesDTOToDomainMapper: GetImagesDTOToDomainMapper
    
    @LazyInjected(\.galleryFeaturesContainer.addToFavoritesDomainToDTOMapper)
    private var addToFavoritesDomainToDTOMapper: AddToFavoritesDomainToDTOMapper
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
    
    func getFavorites() -> AnyPublisher<[FavoriteImage], CoreDataError> {
        galleryFeaturesDataSource.getFavorites()
    }
    
    func addToFavorites(requestDTO: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError> {
        galleryFeaturesDataSource
            .addToFavorites(requestDTO: addToFavoritesDomainToDTOMapper.mapModel(requestDTO))
    }
    
    func removeFromFavorites(requestDTO: FavoriteImage) -> AnyPublisher<Void, CoreDataError> {
        galleryFeaturesDataSource.removeFromFavorites(requestDTO: requestDTO)
    }
}
