//
//  SceneDelegate.swift
//  GalleryApp
//
//  Created by Alexander Sivko on 13.06.24.
//

import UIKit
import Factory
import GalleryApp_Features
import GalleryApp_Navigation

// MARK: - SceneDelegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Injected
    @LazyInjected(\.appCoordinator)
    private var appCoordinator: AppCoordinator
    
    // MARK: Properties
    var window: UIWindow?

    // MARK: Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
        
        let imagesListCoordinator = ImagesListCoordinator(
            coordinatorDependencies: appCoordinator.coordinatorDependencies,
            navigationController: appCoordinator.navigationController,
            delegate: appCoordinator)
        appCoordinator.setRootCoordinator(imagesListCoordinator)
    }
}
