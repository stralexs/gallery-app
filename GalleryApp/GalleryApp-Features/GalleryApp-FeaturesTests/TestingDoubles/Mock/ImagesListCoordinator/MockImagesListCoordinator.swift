//
//  MockImagesListCoordinator.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - MockImagesListCoordinator
final class MockImagesListCoordinator: ImagesListCoordinatorInterface {
    
    var isNavigatedToImageDescription = false
    var isNavigatedToUserFavoriteImages = false
    
    func navigateToImageDescription(images: [GalleryApp_Models.Image], selectedImage: Int) {
        isNavigatedToImageDescription = true
    }
    
    func navigateToUserFavoriteImages() {
        isNavigatedToUserFavoriteImages = true
    }
}
