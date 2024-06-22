//
//  MockNetworkManager.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Moya
import Combine
import GalleryApp_Models
import GalleryApp_Network

@testable import GalleryApp_Features

// MARK: - MockNetworkManager
final class MockNetworkManager: NetworkManagerInterface {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    var getImagesResponse: [ImageDTO]
    private let networkError: MoyaError
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        getImagesResponse: [ImageDTO],
        networkError: MoyaError
    ) {
        self.isPositiveScenario = isPositiveScenario
        self.getImagesResponse = getImagesResponse
        self.networkError = networkError
    }
    
    // MARK: Methods
    func request<T: Request>(_ service: T) -> AnyPublisher<T.ResponseType, MoyaError> {
        if isPositiveScenario {
            return Just(getImagesResponse as! T.ResponseType)
                .setFailureType(to: MoyaError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: networkError)
                .eraseToAnyPublisher()
        }
    }
}
