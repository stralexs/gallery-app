//
//  String+Extension.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 16.06.24.
//

import Foundation

// MARK: - String
public extension String {
    static var empty: String { return String() }
    
    func toURL() -> URL {
        let placeholderImage = Bundle.galleryCore.url(
            forResource: Consts.resourceName,
            withExtension: Consts.fileExtension)!
        return URL(string: self) ?? placeholderImage
    }
}

// MARK: - Consts
private extension String {
    enum Consts {
        static let resourceName = "imagePlaceholder"
        static let fileExtension = "png"
    }
}
