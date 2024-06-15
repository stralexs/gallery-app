//
//  LoadingView.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 15.06.24.
//

import UIKit
import SnapKit

// MARK: - LoadingView
final class LoadingView: UIView {
    
    // MARK: Properties
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = Consts.loadingLabelText
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
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
private extension LoadingView {
    func setUpHierarchy() {
        [loadingLabel, activityIndicator].forEach { addSubview($0) }
    }
    
    func setUpConstraints() {
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingLabel.snp.bottom).offset(50)
        }
    }
}

// MARK: - Consts
private extension LoadingView {
    enum Consts {
        static let loadingLabelText = "Loading"
    }
}
