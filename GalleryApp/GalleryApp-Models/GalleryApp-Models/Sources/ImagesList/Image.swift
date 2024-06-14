//
//  Image.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - Image
public struct Image {
    let id: String
    let description: String
    let createdAt: Date
    let creatorName: String
    let sizeURL: ImageSize
}
