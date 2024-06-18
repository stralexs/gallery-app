//
//  CoordinatorDependencies.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 17.06.24.
//

import Foundation

// MARK: - CoordinatorDependencies
public protocol CoordinatorDependencies {
    
    // MARK: Properties
    var dependecies: [Coordinator] { get }
    
    // MARK: Initializer
    init(dependecies: [Coordinator])
    
    // MARK: Methods
    func add(dependency coordinator: Coordinator)
    func remove(dependency coordinator: Coordinator)
    func removeAll()
}
