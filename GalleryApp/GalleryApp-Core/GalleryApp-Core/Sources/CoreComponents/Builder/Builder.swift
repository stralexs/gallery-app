//
//  Builder.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit

// MARK: - Builder
public protocol Builder {
    func build() -> UIViewController
    func set(delegate: AnyObject) -> Builder
}
