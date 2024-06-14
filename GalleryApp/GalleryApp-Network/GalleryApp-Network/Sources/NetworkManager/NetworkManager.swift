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
    private let decoder: JSONDecoder
    
    // MARK: Initializer
    public init(
        provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
        self.provider = provider
    }
    
    // MARK: Methods
    public func request<T: Request>(_ service: T) -> AnyPublisher<T.ResponseType, MoyaError> {
        provider.requestPublisher(MultiTarget(service.target))
            .filterSuccessfulStatusCodes()
            .map(T.ResponseType.self, using: decoder)
            .eraseToAnyPublisher()
    }
}
