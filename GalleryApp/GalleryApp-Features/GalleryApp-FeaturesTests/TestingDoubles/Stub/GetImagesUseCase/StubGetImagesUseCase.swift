//
//  StubGetImagesUseCase.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Moya
import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - StubGetImagesUseCase
final class StubGetImagesUseCase: GetImagesUseCase {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    var getImagesResponse: [GalleryApp_Models.Image]
    private let networkError: MoyaError
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        getImagesResponse: [GalleryApp_Models.Image],
        networkError: MoyaError
    ) {
        self.isPositiveScenario = isPositiveScenario
        self.getImagesResponse = getImagesResponse
        self.networkError = networkError
    }
    
    // MARK: Methods
    func execute(request: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> {
        if isPositiveScenario {
            return Just(getImagesResponse)
                .setFailureType(to: MoyaError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: networkError)
                .eraseToAnyPublisher()
        }
    }
}
