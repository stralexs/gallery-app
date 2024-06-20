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
    func onViewWillAppear()
}

public extension ViewModelInput {
    func onViewDidLoad() {}
    func onViewWillAppear() {}
}

// MARK: - ViewModelOutput
public protocol ViewModelOutput {
    associatedtype T
    var output: T { get }
}
