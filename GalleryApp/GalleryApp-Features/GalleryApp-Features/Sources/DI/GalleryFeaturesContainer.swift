//
//  GalleryFeaturesContainer.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory

// MARK: - GalleryFeaturesContainer
final class GalleryFeaturesContainer: SharedContainer {
    
    // MARK: Static
    static let shared = GalleryFeaturesContainer(manager: .init())
    
    // MARK: Properties
    let manager: ContainerManager
    
    // MARK: Initializer
    private init(manager: ContainerManager) {
        self.manager = manager
    }
}

// MARK: - Services
extension GalleryFeaturesContainer {
    var getImagesUseCase: Factory<(any GetImagesUseCase)> {
        self { DefaultGetImagesUseCase() }
    }
    
    var getUserFavoriteImagesUseCase: Factory<(any GetUserFavoriteImagesUseCase)> {
        self { DefaultGetUserFavoriteImagesUseCase() }
    }
    
    var imagesListViewModel: Factory<(any ImagesListViewModel)> {
        self { DefaultImagesListViewModel() }
    }
    
    var galleryFeaturesRepository: Factory<GalleryFeaturesRepository> {
        self { DefaultGalleryFeaturesRepository() }
    }
    
    var galleryFeaturesDataSource: Factory<GalleryFeaturesDataSource> {
        self { DefaultGalleryFeaturesDataSource() }
    }
    
    var getImagesDTOToDomainMapper: Factory<GetImagesDTOToDomainMapper> {
        self { GetImagesDTOToDomainMapper() }
    }
    
    var imageCollectionViewCellViewModel: Factory<ImageCollectionViewCellViewModel> {
        self { DefaultImageCollectionViewCellViewModel() }.cached
    }
}
