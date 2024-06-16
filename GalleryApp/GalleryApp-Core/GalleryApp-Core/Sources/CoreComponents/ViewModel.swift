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
    func onViewDidAppear()
    func onViewDidDisappear()
}

public extension ViewModelInput {
    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
    func onViewDidDisappear() {}
}

// MARK: - ViewModelOutput
public protocol ViewModelOutput {
    var viewTitle: String { get }
}

public extension ViewModelOutput {
    var viewTitle: String { .empty }
}
