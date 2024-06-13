//
//  BaseTargetType.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Moya

// MARK: - BaseTargetType
public protocol BaseTargetType: TargetType {}

// MARK: - Default implementation
public extension BaseTargetType {
    var baseURL: URL {
        URL(string: RouteBuilder.baseURL)!
    }
    
    var headers: [String: String]? {
        RouteBuilder.headers
    }
}
