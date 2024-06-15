//
//  GalleryFeatures+Injection.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory

// MARK: - Container
extension Container {
    var galleryFeaturesContainer: GalleryFeaturesContainer { .shared }
}
