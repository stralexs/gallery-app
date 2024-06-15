//
//  ImageDescription+Injection.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import Factory

// MARK: - Container
extension Container {
    var imageDescriptionContainer: ImageDescriptionContainer { .shared }
}
