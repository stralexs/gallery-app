//
//  UserFavoriteImageTableViewCell.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import Kingfisher
import SnapKit

// MARK: - UserFavoriteImageTableViewCell
final class UserFavoriteImageTableViewCell: UITableViewCell {
      
    // MARK: Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Consts.imageCornerRadius
        return imageView
    }()
    
    // MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHierarchy()
        setUpConstraints()
        spinIndicator(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
    
    // MARK: Methods
    func configure(with imageUrl: URL) {
        cellImageView.kf.setImage(with: imageUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                self.cellImageView.image = value.image
            case .failure:
                self.setDefaultImageWhenFailed()
            }
            spinIndicator(false)
        }
    }
}

// MARK: - Private
private extension UserFavoriteImageTableViewCell {
    func setUpHierarchy() {
        [activityIndicator, cellImageView].forEach { contentView.addSubview($0) }
    }
    
    func setUpConstraints() {
        cellImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setDefaultImageWhenFailed() {
        let warningImage = UIImage(systemName: Consts.warningImageName)
        cellImageView.image = warningImage
        cellImageView.tintColor = .black
    }
    
    func spinIndicator(_ isLoading: Bool) {
        if isLoading {
            self.activityIndicator.startAnimating()
            self.cellImageView.isHidden = true
        } else {
            self.activityIndicator.stopAnimating()
            self.cellImageView.isHidden = false
        }
    }
}

// MARK: - Consts
private extension UserFavoriteImageTableViewCell {
    enum Consts {
        static let imageCornerRadius: CGFloat = 20
        static let warningImageName = "exclamationmark.triangle.fill"
    }
}

