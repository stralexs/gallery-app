//
//  BindableView.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - BindableView
public protocol BindableView: Subscriptionable {
    
    // MARK: Associatedtype
    associatedtype ViewModel
    
    // MARK: Methods
    func bind(to viewModel: ViewModel)
}
