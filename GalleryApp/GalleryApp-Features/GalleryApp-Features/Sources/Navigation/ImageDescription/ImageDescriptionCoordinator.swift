//
//  ImageDescriptionCoordinator.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import GalleryApp_Navigation
import GalleryApp_Models

// MARK: - ImageDescriptionCoordinator
final class ImageDescriptionCoordinator: NavigationCoordinator {
    
    // MARK: Properties
    private var images: [GalleryApp_Models.Image] = []
    private var selectedImage: Int = 0
    
    // MARK: Methods
    override func start() {
        let imageDescriptionViewController = ImageDescriptionBuilder()
            .set(images: images, selectedImage: selectedImage)
            .set(delegate: self)
            .build()
        self.startViewController = imageDescriptionViewController
        navigationController.pushViewController(imageDescriptionViewController, animated: true)
    }
    
    // MARK: Initializer
    init(
        coordinatorDependencies: CoordinatorDependencies,
        navigationController: GalleryNavigationCoordinatorInterface,
        delegate: CoordinatorFlowListener,
        images: [GalleryApp_Models.Image],
        selectedImage: Int
    ) {
        self.images = images
        self.selectedImage = selectedImage
        super.init(
            coordinatorDependencies: coordinatorDependencies,
            navigationController: navigationController,
            delegate: delegate
        )
    }
}
