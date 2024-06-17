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
    // MARK: Use case
    var getImagesUseCase: Factory<any GetImagesUseCase> {
        self { DefaultGetImagesUseCase() }
    }
    
    var getUserFavoriteImagesUseCase: Factory<any GetUserFavoriteImagesUseCase> {
        self { DefaultGetUserFavoriteImagesUseCase() }
    }
    
    var addToFavoritesUseCase: Factory<any AddToFavoritesUseCase> {
        self { DefaultAddToFavoritesUseCase() }
    }
    
    var removeFromFavoritesUseCase: Factory<any RemoveFromFavoritesUseCase> {
        self { DefaultRemoveFromFavoritesUseCase() }
    }
    
    // MARK: ViewModel
    var imagesListViewModel: Factory<any ImagesListViewModel> {
        self { DefaultImagesListViewModel() }
    }
    
    var imageCollectionViewCellViewModel: Factory<any ImageCollectionViewCellViewModel> {
        self { DefaultImageCollectionViewCellViewModel() }
    }
    
    // MARK: Repository
    var galleryFeaturesRepository: Factory<GalleryFeaturesRepository> {
        self { DefaultGalleryFeaturesRepository() }
    }
    
    // MARK: Data source
    var galleryFeaturesDataSource: Factory<GalleryFeaturesDataSource> {
        self { DefaultGalleryFeaturesDataSource() }
    }
    
    // MARK: Mapper
    var getImagesDTOToDomainMapper: Factory<GetImagesDTOToDomainMapper> {
        self { GetImagesDTOToDomainMapper() }
    }
}
