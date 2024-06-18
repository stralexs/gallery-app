//
//  GalleryNavigationController.swift
//  GalleryApp-Navigation
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit

// MARK: - GalleryNavigationController
public class GalleryNavigationController: UINavigationController {
    
    // MARK: Initializer
    override init(rootViewController: UIViewController = UIViewController()) {
        super.init(rootViewController: rootViewController)
        setUpNavigationBarAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - GalleryNavigationCoordinatorInterface
extension GalleryNavigationController: GalleryNavigationCoordinatorInterface {
    public func setBackButtonTitle(_ title: String) {
        viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    public func setNavigationTitle(_ title: String) {
        viewControllers.last?.title = title
    }
    
    public func disableNavigationTitle() {
        viewControllers.last?.navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - Private
private extension GalleryNavigationController {
    func setUpNavigationBarAppearance() {
        navigationBar.tintColor = .black
        navigationBar.prefersLargeTitles = true
    }
}
