//
//  AppCoordinator.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 17.06.24.
//

import UIKit

// MARK: - AppCoordinator
public final class AppCoordinator: NavigationCoordinator {
    
    // MARK: Initializer
    init(
        coordinatorDependencies: CoordinatorDependencies = DefaultCoordinatorDependencies(),
        navigationController: GalleryNavigationCoordinatorInterface = GalleryNavigationController()
    ) {
        super.init(coordinatorDependencies: coordinatorDependencies, navigationController: navigationController, delegate: nil)
    }
    
    // MARK: Methods
    public override func start() {
        coordinatorDependencies.dependecies.last?.start()
    }
    
    public func setRootCoordinator(_ coordinator: Coordinator) {
        coordinatorDependencies.removeAll()
        navigationController.viewControllers = []
        coordinatorDependencies.add(dependency: coordinator)
        start()
    }
}
