//
//  GalleryErrorViewModifier.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 17.06.24.
//

import SwiftUI

// MARK: - ErrorViewModifier
public struct ErrorViewModifier: ViewModifier {
    
    // MARK: Properties
    let isErrorOccurred: Bool
    var retryAction: () -> Void
    
    // MARK: Methods
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isErrorOccurred {
                SUIErrorView(retryAction: retryAction)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}
