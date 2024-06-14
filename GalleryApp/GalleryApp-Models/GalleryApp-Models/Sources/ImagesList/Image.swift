//
//  Image.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - Image
public struct Image {
    
    // MARK: Properties
    public let id: String
    public let description: String
    public let createdAt: String
    public let creatorName: String
    public let sizeURL: ImageSizeURL
    
    // MARK: Initializer
    public init(
        id: String,
        description: String,
        createdAt: String,
        creatorName: String,
        sizeURL: ImageSizeURL
    ) {
        self.id = id
        self.description = description
        self.createdAt = createdAt
        self.creatorName = creatorName
        self.sizeURL = sizeURL
    }
}

// MARK: - Hashable
extension Image: Hashable {
    public static func == (lhs: Image, rhs: Image) -> Bool {
        lhs.id == rhs.id
    }
}
