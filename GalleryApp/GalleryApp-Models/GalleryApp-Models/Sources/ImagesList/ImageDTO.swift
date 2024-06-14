//
//  ImageDTO.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 13.06.24.
//

import Foundation

// MARK: - ImageDTO
public struct ImageDTO: Decodable {
    let id: String
    let altDescription: String
    let createdAt: String
    let user: User
    let urls: ImageURL
}

// MARK: - ImageURL
public extension ImageDTO {
    struct ImageURL: Decodable {
        let small: String
        let full: String
    }
}

// MARK: - User
public extension ImageDTO {
    struct User: Decodable {
        let name: String
    }
}
