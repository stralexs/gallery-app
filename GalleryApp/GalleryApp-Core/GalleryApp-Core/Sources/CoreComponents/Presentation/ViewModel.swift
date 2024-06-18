//
//  ViewModel.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - ViewModelInput
public protocol ViewModelInput {
    func onViewDidLoad()
}

public extension ViewModelInput {
    func onViewDidLoad() {}
}

// MARK: - ViewModelOutput
public protocol ViewModelOutput {
    associatedtype T
    var output: T { get }
}
