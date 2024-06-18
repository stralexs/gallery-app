//
//  Network+Injection.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Factory

// MARK: - Injection
public extension Container {
    var networkManager: Factory<NetworkManagerInterface> {
        self { NetworkManager() }.singleton
    }
}
