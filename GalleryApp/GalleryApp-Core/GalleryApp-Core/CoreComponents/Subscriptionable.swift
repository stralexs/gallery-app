//
//  Subscriptionable.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

import Combine

// MARK: - Subscriptionable
public protocol Subscriptionable {
    var subscriptions: Set<AnyCancellable> { get }
}
