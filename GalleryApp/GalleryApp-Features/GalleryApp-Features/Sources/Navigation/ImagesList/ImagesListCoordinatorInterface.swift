//
//  ImagesListCoordinatorInterface.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import GalleryApp_Models

// MARK: - ImagesListCoordinatorInterface
protocol ImagesListCoordinatorInterface: AnyObject {
    func navigateToImageDescription(images: [GalleryApp_Models.Image], selectedImage: Int)
    func navigateToUserFavoriteImages()
}
