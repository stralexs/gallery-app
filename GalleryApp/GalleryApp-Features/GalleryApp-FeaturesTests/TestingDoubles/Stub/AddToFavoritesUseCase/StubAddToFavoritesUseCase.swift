//
//  StubAddToFavoritesUseCase.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - StubAddToFavoritesUseCase
final class StubAddToFavoritesUseCase: AddToFavoritesUseCase {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    private let togglingFavoriteResponse: Void
    private let coreDataError: CoreDataError
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        togglingFavoriteResponse: Void,
        coreDataError: CoreDataError
    ) {
        self.isPositiveScenario = isPositiveScenario
        self.togglingFavoriteResponse = togglingFavoriteResponse
        self.coreDataError = coreDataError
    }
    
    // MARK: Methods
    func execute(request: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError> {
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
