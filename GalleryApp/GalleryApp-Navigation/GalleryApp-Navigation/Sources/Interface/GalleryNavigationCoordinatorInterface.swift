//
//  GalleryNavigationCoordinatorInterface.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit

// MARK: - GalleryNavigationCoordinatorInterface
public protocol GalleryNavigationCoordinatorInterface: UINavigationController {
    func setBackButtonTitle(_ title: String)
    func setNavigationTitle(_ title: String)
    func disableNavigationTitle()
    func addRightNavigationItem(target: Any?, action: Selector?)
}
