//
//  CoreData+Injection.swift
//  GalleryApp-CoreData
//
//  Created by Alexander Sivko on 16.06.24.
//

import Factory

// MARK: - Injection
public extension Container {
    var coreDataManager: Factory<CoreDataManagerProtocol> {
        self { CoreDataManager() }.singleton
    }
}
