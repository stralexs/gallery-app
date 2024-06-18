//
//  CoordinatorFlowListener.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 17.06.24.
//

import Foundation

// MARK: - CoordinatorFlowListener
public protocol CoordinatorFlowListener: AnyObject {
    func onFinish(_ coordinator: Coordinator)
}
