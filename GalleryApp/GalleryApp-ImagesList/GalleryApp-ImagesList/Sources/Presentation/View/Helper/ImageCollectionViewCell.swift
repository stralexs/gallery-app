//
//  ImageCollectionViewCell.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - ImageCollectionViewCell
final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpConstraints()
        spinIndicator(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(with url: URL) {
        imageView.kf.setImage(with: url) { [weak self] _ in
            guard let self else { return }
            self.spinIndicator(false)
        }
    }
}

// MARK: - Private
private extension ImageCollectionViewCell {
    func setUpHierarchy() {
        [activityIndicator, imageView].forEach { contentView.addSubview($0) }
        contentView.clipsToBounds = true
    }
    
    func setUpConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func spinIndicator(_ isLoading: Bool) {
        if isLoading {
            self.activityIndicator.startAnimating()
            self.imageView.isHidden = true
        } else {
            self.activityIndicator.stopAnimating()
            self.imageView.isHidden = false
        }
    }
}
