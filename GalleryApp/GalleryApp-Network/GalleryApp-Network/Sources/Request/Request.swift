//
//  Request.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Moya

// MARK: - Request
public protocol Request {
    associatedtype ResponseType: Decodable
    associatedtype Target: BaseTargetType
    var target: Target { get }
}
