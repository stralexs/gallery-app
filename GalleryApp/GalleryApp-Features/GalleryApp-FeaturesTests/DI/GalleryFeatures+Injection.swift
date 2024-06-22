//
//  GalleryFeatures+Injection.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Moya
import Factory
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - GalleryFeaturesContainer
extension GalleryFeaturesContainer {
    static func registerMocks(
        isPositiveScenario: Bool = true,
        getImagesResponseDTO: [ImageDTO] = [],
        getImagesResponse: [GalleryApp_Models.Image] = [],
        getFavoritesResponse: [FavoriteImage] = [],
        togglingFavoritesResponse: Void = GalleryFeaturesMocks.togglingFavoriteResponse,
        networkError: MoyaError = GalleryFeaturesMocks.networkError,
        coreDataError: CoreDataError = GalleryFeaturesMocks.coreDataError
    ) {
        shared.getImagesUseCase.register {
            StubGetImagesUseCase(
                isPositiveScenario: isPositiveScenario,
                getImagesResponse: getImagesResponse,
                networkError: networkError
            )
        }
        
        shared.getUserFavoriteImagesUseCase.register {
            StubGetUserFavoriteImagesUseCase(
                isPositiveScenario: isPositiveScenario,
                getFavoritesResponse: getFavoritesResponse,
                coreDataError: coreDataError
            )
        }
        
        shared.addToFavoritesUseCase.register {
            StubAddToFavoritesUseCase(
                isPositiveScenario: isPositiveScenario,
                togglingFavoriteResponse: togglingFavoritesResponse,
                coreDataError: coreDataError
            )
        }
        
        shared.removeFromFavoritesUseCase.register {
            StubRemoveFromFavoritesUseCase(
                isPositiveScenario: isPositiveScenario,
                togglingFavoriteResponse: togglingFavoritesResponse,
                coreDataError: coreDataError
            )
        }
        
        shared.galleryFeaturesRepository.register {
            StubGalleryFeaturesRepository(
                isPositiveScenario: isPositiveScenario,
                getImagesResponse: getImagesResponse,
                getFavoritesResponse: getFavoritesResponse,
                togglingFavoriteResponse: togglingFavoritesResponse,
                networkError: networkError,
                coreDataError: coreDataError
            )
        }
        
        shared.galleryFeaturesDataSource.register {
            StubGalleryFeaturesDataSource(
                isPositiveScenario: isPositiveScenario,
                getImagesResponse: getImagesResponseDTO,
                getFavoritesResponse: getFavoritesResponse,
                togglingFavoriteResponse: togglingFavoritesResponse,
                networkError: networkError,
                coreDataError: coreDataError
            )
        }
    }
}

// MARK: - Container
extension Container {
    static func registerNetworkMock(
        isPositiveScenario: Bool = true,
        getImagesResponseDTO: [ImageDTO] = [],
        networkError: MoyaError = GalleryFeaturesMocks.networkError
    ) {
        shared.networkManager.register {
            MockNetworkManager(
                isPositiveScenario: isPositiveScenario,
                getImagesResponse: getImagesResponseDTO,
                networkError: networkError
            )
        }
    }
    
    static func registerCoreDataMock(
        isPositiveScenario: Bool = true,
        getFavoritesResponse: [FavoriteImage] = [],
        togglingFavoritesResponse: Void = GalleryFeaturesMocks.togglingFavoriteResponse,
        coreDataError: CoreDataError = GalleryFeaturesMocks.coreDataError
    ) {
        shared.coreDataManager.register {
            MockCoreDataManager(
                isPositiveScenario: isPositiveScenario,
                getFavoritesResponse: getFavoritesResponse,
                togglingFavoriteResponse: togglingFavoritesResponse,
                coreDataError: coreDataError
            )
        }
    }
}
