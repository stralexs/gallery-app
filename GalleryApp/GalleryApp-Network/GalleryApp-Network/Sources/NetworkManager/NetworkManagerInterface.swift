//
//  NetworkManagerInterface.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Moya
import Combine

// MARK: - NetworkManagerInterface
public protocol NetworkManagerInterface {
    func request<T: Request>(_ service: T) -> AnyPublisher<T.ResponseType, MoyaError>
}
