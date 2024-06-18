//
//  ImageSizeURL.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 14.06.24.
//

import GalleryApp_Core

// MARK: - ImageSizeURL
public struct ImageSizeURL: Hashable {
    
    // MARK: Properties
    public let small: URL
    public let full: URL
    
    // MARK: Initializer
    public init(small: String, full: String) {
        self.small = small.toURL()
        self.full = small.toURL()
    }
}
