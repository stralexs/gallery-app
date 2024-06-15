//
//  SceneDelegate.swift
//  GalleryApp
//
//  Created by Alexander Sivko on 13.06.24.
//

import UIKit
import SwiftUI
import GalleryApp_ImagesList
import GalleryApp_ImageDescription
import GalleryApp_Models

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties
    var window: UIWindow?

    // MARK: Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
//        let viewController = ImagesListViewController()
//        let navigation = UINavigationController(rootViewController: viewController)
//        window?.rootViewController = navigation
//        let hostingController = UIHostingController(rootView: ImageDescriptionView(viewModel: <#_#>, images: [
//            GalleryApp_Models.Image(
//                id: "CVbr5RR0yac",
//                description: "a living room with a chair and a potted plant",
//                createdAt: "06 11 2024",
//                creatorName: "Julie Guzal",
//                sizeURL: .init(
//                    small: "https://images.unsplash.com/photo-1718070477385-eed35e367ec8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwxfHx8fHx8Mnx8MTcxODQ1MDc5OXw&ixlib=rb-4.0.3&q=80&w=400",
//                    full: "https://images.unsplash.com/photo-1718070477385-eed35e367ec8?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwxfHx8fHx8Mnx8MTcxODQ1MDc5OXw&ixlib=rb-4.0.3&q=85"
//                )
//            ),
//            GalleryApp_Models.Image(
//                id: "GDs4VOWS5wI",
//                description: "an aerial view of a city at night",
//                createdAt: "14 06 2024",
//                creatorName: "Michael Pointner",
//                sizeURL: .init(
//                    small: "https://images.unsplash.com/photo-1717852613749-2104b6bd6b39?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwzMnx8fHx8fDJ8fDE3MTg0NTUxODZ8&ixlib=rb-4.0.3&q=80&w=400",
//                    full: "https://images.unsplash.com/photo-1717852613749-2104b6bd6b39?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwzMnx8fHx8fDJ8fDE3MTg0NTUxODZ8&ixlib=rb-4.0.3&q=85"
//                )
//            )
//        ], selectedImage: 0))
//        window?.rootViewController = hostingController
        
        window?.makeKeyAndVisible()
    }
}
