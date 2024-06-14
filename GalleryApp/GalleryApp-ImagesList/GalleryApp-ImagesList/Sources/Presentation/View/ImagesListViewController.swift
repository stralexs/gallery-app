//
//  ImagesListViewController.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import Combine
import Factory
import GalleryApp_Core
import Kingfisher

// TODO: Remove public when navigation is ready and remove Kingfisher

// MARK: - ImagesListViewController
public final class ImagesListViewController: UIViewController, ViewController {
    
    // MARK: Typealias
    public typealias ViewModel = ImagesListViewModel
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.imagesListViewModel)
    private var viewModel: any ViewModel
        
    // MARK: Properties
    private(set) public var subscriptions: Set<AnyCancellable> = []
}

// MARK: - Lifecycle
public extension ImagesListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bind(to: viewModel)
        viewModel.getImages()
    }
}

// MARK: - Bind
public extension ImagesListViewController {
    func bind(to viewModel: any ViewModel) {
        
    }
}
