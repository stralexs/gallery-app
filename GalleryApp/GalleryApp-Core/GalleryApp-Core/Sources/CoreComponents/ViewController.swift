//
//  ViewController.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - ViewController
public protocol ViewController: Subscriptionable {
    
    // MARK: Associatedtype
    associatedtype ViewModel
    
    // MARK: Methods
    func bind(to viewModel: ViewModel)
}
