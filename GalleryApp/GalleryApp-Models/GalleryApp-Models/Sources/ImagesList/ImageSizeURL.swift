//
//  ImageSizeURL.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - ImageSizeURL
public struct ImageSizeURL: Hashable {
    
    // MARK: Properties
    public let small: URL
    public let full: URL
    
    // MARK: Initializer
    public init(small: String, full: String) {
        let placeholderImage = Bundle(identifier: Consts.bundleID)!.url(
            forResource: Consts.resourceName,
            withExtension: Consts.fileExtension)!
        self.small = URL(string: small) ?? placeholderImage
        self.full = URL(string: full) ?? placeholderImage
    }
}

// MARK: - Consts
private extension ImageSizeURL {
    enum Consts {
        static let bundleID = "alexander-sivko.GalleryApp-Models"
        static let resourceName = "imagePlaceholder"
        static let fileExtension = "png"
    }
}
