//
//  StubGalleryFeaturesDataSource.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Moya
import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - StubGalleryFeaturesDataSource
final class StubGalleryFeaturesDataSource: GalleryFeaturesDataSource {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    var getImagesResponse: [ImageDTO]
    var getFavoritesResponse: [FavoriteImage]
    private let togglingFavoriteResponse: Void
    private let networkError: MoyaError
    private let coreDataError: CoreDataError
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        getImagesResponse: [ImageDTO],
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
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError> {
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
    
    func addToFavorites(requestDTO: FavoriteImage) -> AnyPublisher<Void, CoreDataError> {
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

