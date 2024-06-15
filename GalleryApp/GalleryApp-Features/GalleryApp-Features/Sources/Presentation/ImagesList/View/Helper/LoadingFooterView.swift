//
//  LoadingFooterView.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 15.06.24.
//

import UIKit
import SnapKit

// MARK: - LoadingFooterView
final class LoadingFooterView: UICollectionReusableView {
    
    // MARK: Properties
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpConstraints()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension LoadingFooterView {
    func setUpHierarchy() {
        addSubview(activityIndicator)
        backgroundColor = .clear
    }
    
    func setUpConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
