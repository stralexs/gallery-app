//
//  StubGalleryFeaturesRepository.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Moya
import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - GalleryFeaturesRepository
final class StubGalleryFeaturesRepository: GalleryFeaturesRepository {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    var getImagesResponse: [GalleryApp_Models.Image]
    var getFavoritesResponse: [FavoriteImage]
    var togglingFavoriteResponse: Void
    private let networkError: MoyaError
    private let coreDataError: CoreDataError
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        getImagesResponse: [GalleryApp_Models.Image],
        getFavoritesResponse: [FavoriteImage],
        togglingFavoriteResponse: Void,
        networkError: MoyaError,
        coreDataError: CoreDataError
    ) {
        self.isPositiveScenario = isPositiveScenario
        self.getImagesResponse = getImagesResponse
        self.getFavoritesResponse = getFavoritesResponse
        self.togglingFavoriteResponse = togglingFavoriteResponse
        self.networkError = networkError
        self.coreDataError = coreDataError
    }
    
    // MARK: Methods
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        if isPositiveScenario {
            return Just(getImagesResponse)
                .setFailureType(to: MoyaError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: networkError)
                .eraseToAnyPublisher()
        }
    }
    
    func getFavorites() -> AnyPublisher<[FavoriteImage], CoreDataError> {
        if isPositiveScenario {
            return Just(getFavoritesResponse)
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
    
    func addToFavorites(requestDTO: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError> {
        if isPositiveScenario {
            return Just(togglingFavoriteResponse)
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
    
    func removeFromFavorites(requestDTO: FavoriteImage) -> AnyPublisher<Void, CoreDataError> {
        if isPositiveScenario {
            return Just(togglingFavoriteResponse)
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
}
