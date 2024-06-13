//
//  NetworkManagerProtocol.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Moya
import Combine

// MARK: - NetworkManagerProtocol
public protocol NetworkManagerProtocol {
    func request<T: Request>(_ service: T) -> AnyPublisher<T.ResponseType, MoyaError>
}
