//
//  SUIPageControl.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 15.06.24.
//

import SwiftUI

// MARK: - SUIPageControl
struct SUIPageControl: UIViewRepresentable {
    
    // MARK: Properties
    private let numberOfPages: Int
    @Binding private var currentPage: Int
    
    // MARK: Initializer
    public init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        _currentPage = currentPage
    }
}

// MARK: - Setup
extension SUIPageControl {
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}

// MARK: - Preview
#Preview {
    SUIPageControl(
        numberOfPages: 5,
        currentPage: .constant(1)
    )
}

