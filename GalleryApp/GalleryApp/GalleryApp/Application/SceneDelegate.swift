//
//  SceneDelegate.swift
//  GalleryApp
//
//  Created by Alexander Sivko on 13.06.24.
//

import UIKit
import GalleryApp_ImagesList

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties
    var window: UIWindow?

    // MARK: Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = ImagesListViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
