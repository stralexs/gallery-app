//
//  SUIErrorView.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 17.06.24.
//

import SwiftUI

// MARK: - SUIErrorView
struct SUIErrorView: UIViewRepresentable {
    
    // MARK: Properties
    private let retryAction: () -> Void
    
    // MARK: Initializer
    init(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
    }
    
    // MARK: Methods
    func makeUIView(context: Context) -> ErrorView {
        let errorView = ErrorView()
        errorView.retryAction = retryAction
        return errorView
    }
    
    func updateUIView(_ uiView: ErrorView, context: Context) {}
}

// MARK: - Preview
#Preview {
    SUIErrorView(retryAction: {})
}
