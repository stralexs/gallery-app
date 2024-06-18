//
//  DefaultCoordinatorDependencies.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 17.06.24.
//

import Foundation

// MARK: - DefaultCoordinatorDependencies
public class DefaultCoordinatorDependencies: CoordinatorDependencies, ExpressibleByArrayLiteral {
    
    // MARK: Properties
    public private(set) var dependecies: [Coordinator]
    
    // MARK: Initializer
    public required init(dependecies: [Coordinator] = []) {
        self.dependecies = dependecies
    }
    
    public convenience required init(arrayLiteral elements: Coordinator...) {
        self.init(dependecies: elements)
    }
    
    // MARK: Methods
    public func add(dependency coordinator: Coordinator) {
        guard !self.dependecies.contains(where: { $0 === coordinator }) else { return }
        self.dependecies.append(coordinator)
    }
    
    public func remove(dependency coordinator: Coordinator) {
        for (i, dependency) in self.dependecies.enumerated() where coordinator === dependency {
            self.dependecies.remove(at: i)
            break
        }
    }
  
    public func removeAll() {
        dependecies.removeAll()
    }
}
