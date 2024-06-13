//
//  NetworkManager.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Combine
import CombineMoya
import Moya

// MARK: - NetworkManager
public final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: Properties
    private let provider: MoyaProvider<MultiTarget>
    
    // MARK: Initializer
    public init(
        provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    ) {
        self.provider = provider
    }
    
    // MARK: Methods
    public func request<T: Request>(_ targetType: T) -> AnyPublisher<T.ResponseType, MoyaError> {
        return provider.requestPublisher(MultiTarget(targetType.target))
            .filterSuccessfulStatusCodes()
            .map(T.ResponseType.self)
            .eraseToAnyPublisher()
    }
}
