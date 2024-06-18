//
//  GalleryHostingController.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import SwiftUI
import GalleryApp_Navigation

// MARK: - GalleryHostingController
public final class GalleryHostingController<Content: View>: UIViewController {
    
    // MARK: Properties
    private let rootView: Content
    
    // MARK: Initializer
    public init(rootView: Content) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    public override func loadView() {
        guard let hostingView = UIHostingController(rootView: rootView).view else {
            fatalError("View is not implemented")
        }
        view = hostingView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? GalleryNavigationController
        else { return }
        navigationController.disableNavigationTitle()
    }
}
