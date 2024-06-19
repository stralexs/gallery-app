//
//  NavigationCoordinator.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 17.06.24.
//

import UIKit

// MARK: - NavigationCoordinator
open class NavigationCoordinator: NSObject, Coordinator {
    
    // MARK: Delegate
    public weak var delegate: CoordinatorFlowListener?
    
    // MARK: Navigation
    public weak var startViewController: UIViewController?
    public let navigationController: GalleryNavigationCoordinatorInterface
    
    // MARK: Dependecies
    public let coordinatorDependencies: CoordinatorDependencies
    
    // MARK: Initializer
    public init(
        coordinatorDependencies: CoordinatorDependencies = DefaultCoordinatorDependencies(),
        navigationController: GalleryNavigationCoordinatorInterface,
        delegate: CoordinatorFlowListener?
    ) {
        self.coordinatorDependencies = coordinatorDependencies
        self.navigationController = navigationController
        self.delegate = delegate
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: Methods
    open func start() { }
    
    open func stop() {
        let delegate = (self.delegate as? UINavigationControllerDelegate)
        self.navigationController.delegate = delegate
        self.delegate?.onFinish(self)
    }
}

// MARK: - UINavigationControllerDelegate
extension NavigationCoordinator: UINavigationControllerDelegate {
    open func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let startViewController,
              let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(fromViewController),
              fromViewController == startViewController
        else { return }

        stop()
    }
}

// MARK: - CoordinatorFlowListener
extension NavigationCoordinator: CoordinatorFlowListener {
    public func onFinish(_ coordinator: Coordinator) {
        coordinatorDependencies.remove(dependency: coordinator)
    }
}
