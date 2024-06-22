//
//  StubGetUserFavoriteImagesUseCase.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - StubGetUserFavoriteImagesUseCase
final class StubGetUserFavoriteImagesUseCase: GetUserFavoriteImagesUseCase {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    var getFavoritesResponse: [FavoriteImage]
    private let coreDataError: CoreDataError
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        getFavoritesResponse: [FavoriteImage],
        coreDataError: CoreDataError
    ) {
        self.isPositiveScenario = isPositiveScenario
        self.getFavoritesResponse = getFavoritesResponse
        self.coreDataError = coreDataError
    }
    
    // MARK: Methods
    func execute(request: ()) -> AnyPublisher<[FavoriteImage], CoreDataError> {
        if isPositiveScenario {
            return Just(getFavoritesResponse)
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
}
