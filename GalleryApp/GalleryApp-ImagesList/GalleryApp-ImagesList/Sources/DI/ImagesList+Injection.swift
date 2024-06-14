//
//  ImagesList+Injection.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory

// MARK: - Container
extension Container {
    var imagesListContainer: ImagesListContainer { .shared }
}
