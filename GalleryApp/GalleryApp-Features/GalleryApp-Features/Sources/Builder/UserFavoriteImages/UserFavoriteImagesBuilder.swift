//
//  UserFavoriteImagesBuilder.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import SwiftUI
import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - UserFavoriteImagesBuilder
final class UserFavoriteImagesBuilder: Builder {

    // MARK: Methods
    public func build() -> UIViewController {
        UserFavoriteImagesViewController()
    }

    public func set(delegate: AnyObject) -> Builder {
        return self
    }
}
