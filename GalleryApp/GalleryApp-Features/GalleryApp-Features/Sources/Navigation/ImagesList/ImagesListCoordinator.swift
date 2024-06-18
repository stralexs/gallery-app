//
//  ImagesListCoordinator.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import GalleryApp_Navigation
import GalleryApp_Models

// MARK: - ImagesListCoordinator
public final class ImagesListCoordinator: NavigationCoordinator {
    
    // MARK: Methods
    override public func start() {
        let imagesListViewController = ImagesListBuilder().set(delegate: self).build()
        self.startViewController = imagesListViewController
        navigationController.pushViewController(imagesListViewController, animated: false)
    }
    
    // MARK: Initializer
    public init(
        coordinatorDependencies: CoordinatorDependencies,
        navigationController: UINavigationController,
        delegate: CoordinatorFlowListener
    ) {
        super.init(
            coordinatorDependencies: coordinatorDependencies,
            navigationController: navigationController,
            delegate: delegate
        )
    }
}

// MARK: - ImagesListCoordinatorInterface
extension ImagesListCoordinator: ImagesListCoordinatorInterface {
    func navigateToImageDescription(images: [GalleryApp_Models.Image], selectedImage: Int) {
        let coordinator = ImageDescriptionCoordinator(
            coordinatorDependencies: coordinatorDependencies,
            navigationController: navigationController,
            delegate: self,
            images: images,
            selectedImage: selectedImage)
        coordinatorDependencies.add(dependency: coordinator)
        coordinator.start()
    }
    
    func navigateToUserFavoriteImages() {
        let coordinator = UserFavoriteImagesCoordinator(
            coordinatorDependencies: coordinatorDependencies,
            navigationController: navigationController,
            delegate: self)
        coordinatorDependencies.add(dependency: coordinator)
        coordinator.start()
    }
}
