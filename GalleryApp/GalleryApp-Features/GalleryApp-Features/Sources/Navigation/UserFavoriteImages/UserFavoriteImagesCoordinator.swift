//
//  UserFavoriteImagesCoordinator.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import GalleryApp_Navigation
import GalleryApp_Models

// MARK: - UserFavoriteImagesCoordinator
final class UserFavoriteImagesCoordinator: NavigationCoordinator {
    
    // MARK: Methods
    override func start() {
        let userFavoriteImagesViewController = UserFavoriteImagesBuilder().build()
        self.startViewController = userFavoriteImagesViewController
        navigationController.pushViewController(userFavoriteImagesViewController, animated: true)
    }
    
    // MARK: Initializer
    init(
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
