//
//  ImageDescriptionBuilder.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import SwiftUI
import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - ImageDescriptionBuilder
final class ImageDescriptionBuilder: Builder {
    
    // MARK: Injected
    @Injected(\.galleryFeaturesContainer.imageDescriptionViewModel)
    private var viewModel: any ImageDescriptionViewModel
    
    // MARK: Properties
    private var images: [GalleryApp_Models.Image] = []
    private var selectedImage: Int = 0

    // MARK: Methods
    public func build() -> UIViewController {
        guard let viewModel = viewModel as? DefaultImageDescriptionViewModel
        else { return UIViewController() }
        let rootView = ImageDescriptionView(
            viewModel: viewModel,
            images: images,
            selectedImage: selectedImage)
        let viewController = GalleryHostingController(rootView: rootView)
        return viewController
    }

    public func set(delegate: AnyObject) -> Builder {
        return self
    }
    
    func set(images: [GalleryApp_Models.Image], selectedImage: Int) -> ImageDescriptionBuilder {
        self.images = images
        self.selectedImage = selectedImage
        return self
    }
}
