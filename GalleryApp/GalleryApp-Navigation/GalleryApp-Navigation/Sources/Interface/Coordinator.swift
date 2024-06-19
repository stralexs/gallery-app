//
//  Coordinator.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 17.06.24.
//

import UIKit

// MARK: - Coordinator
public protocol Coordinator: AnyObject {
    
    // MARK: Properties
    var delegate: CoordinatorFlowListener? { get set }
    var startViewController: UIViewController? { get }
    var navigationController: GalleryNavigationCoordinatorInterface { get }
    var coordinatorDependencies: CoordinatorDependencies { get }
    
    // MARK: Methods
    func start()
    func stop()
}
