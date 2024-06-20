//
//  ImageDTO.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 13.06.24.
//

import Foundation

// MARK: - ImageDTO
public struct ImageDTO: Decodable {
    public let id: String
    public let altDescription: String?
    public let createdAt: String
    public let user: User
    public let urls: ImageURL
}

// MARK: - ImageURL
public extension ImageDTO {
    struct ImageURL: Decodable {
        public let small: String
        public let full: String
    }
}

// MARK: - User
public extension ImageDTO {
    struct User: Decodable {
        public let name: String
    }
}
