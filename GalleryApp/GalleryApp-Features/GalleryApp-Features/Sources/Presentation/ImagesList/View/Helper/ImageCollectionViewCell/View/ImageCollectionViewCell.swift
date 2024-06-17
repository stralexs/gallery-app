//
//  ImageCollectionViewCell.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import SnapKit
import Kingfisher
import GalleryApp_Models
import Factory

// MARK: - ImageCollectionViewCell
final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.imageCollectionViewCellViewModel)
    private var viewModel: ImageCollectionViewCellViewModel
    
    // MARK: Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var isFavoriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Consts.heartImageName)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
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
    func configure(with image: GalleryApp_Models.Image) {
//        viewModel.set(image)
//        isFavoriteButton.tintColor = image.isFavorite ? .red : .white
        imageView.kf.setImage(with: image.sizeURL.small) { [weak self] _ in
            guard let self else { return }
            self.spinIndicator(false)
        }
    }
}

// MARK: - Private
private extension ImageCollectionViewCell {
    @objc private func toggleFavorite() {
        print("Hello")
//        viewModel.toggleIsFavorite()
    }
    
    func setUpHierarchy() {
        [activityIndicator, imageView, isFavoriteButton].forEach { contentView.addSubview($0) }
        contentView.clipsToBounds = true
    }
    
    func setUpConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        isFavoriteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.height.width.equalTo(25)
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

// MARK: - Consts
private extension ImageCollectionViewCell {
    enum Consts {
        static let heartImageName = "heart.fill"
    }
}
