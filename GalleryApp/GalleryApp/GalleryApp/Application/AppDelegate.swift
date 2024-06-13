//
//  AppDelegate.swift
//  GalleryApp
//
//  Created by Alexander Sivko on 13.06.24.
//

import UIKit

// MARK: - AppDelegate
@main class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
