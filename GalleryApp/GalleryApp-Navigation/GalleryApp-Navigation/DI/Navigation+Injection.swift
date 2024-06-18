//
//  Navigation+Injection.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 18.06.24.
//

import Factory

// MARK: - Injection
public extension Container {
    var appCoordinator: Factory<AppCoordinator> {
        self { AppCoordinator() }.singleton
    }
}
