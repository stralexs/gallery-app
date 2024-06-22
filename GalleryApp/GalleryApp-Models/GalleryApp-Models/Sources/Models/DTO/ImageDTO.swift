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
    
    public init(
        id: String,
        altDescription: String?,
        createdAt: String,
        user: User,
        urls: ImageURL
    ) {
        self.id = id
        self.altDescription = altDescription
        self.createdAt = createdAt
        self.user = user
        self.urls = urls
    }
}

// MARK: - ImageURL
public extension ImageDTO {
    struct ImageURL: Decodable {
        public let small: String
        public let full: String
        
        public init(small: String, full: String) {
            self.small = small
            self.full = full
        }
    }
}

// MARK: - User
public extension ImageDTO {
    struct User: Decodable {
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
    }
}
