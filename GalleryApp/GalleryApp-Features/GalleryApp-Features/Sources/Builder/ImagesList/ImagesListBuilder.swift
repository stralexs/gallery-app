//
//  ImagesListBuilder.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import Factory
import GalleryApp_Core

// MARK: - ImagesListBuilder
final class ImagesListBuilder: Builder {
    
    // MARK: Properties
    private var delegate: ImagesListCoordinatorInterface?
    
    // MARK: Injected
    @Injected(\.galleryFeaturesContainer.imagesListViewModel)
    private var viewModel: any ImagesListViewModel

    // MARK: Methods
    func build() -> UIViewController {
        viewModel.delegate = delegate
        let viewController = ImagesListViewController(viewModel: viewModel)
        return viewController
    }

    func set(delegate: AnyObject) -> Builder {
        self.delegate = delegate as? ImagesListCoordinatorInterface
        return self
    }
}
