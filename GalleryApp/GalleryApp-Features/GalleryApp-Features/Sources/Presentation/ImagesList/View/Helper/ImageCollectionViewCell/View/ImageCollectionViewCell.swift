//
//  ImageCollectionViewCell.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import Combine
import Factory
import SnapKit
import Kingfisher
import GalleryApp_Models
import GalleryApp_Core

// MARK: - ImageCollectionViewCell
final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Typealias
    public typealias ViewModel = ImageCollectionViewCellViewModel
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.imageCollectionViewCellViewModel)
    private var viewModel: any ImageCollectionViewCellViewModel
    
    // MARK: Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private(set) var subscriptions: Set<AnyCancellable> = []
    
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
        bind(to: viewModel)
        setUpHierarchy()
        setUpConstraints()
        spinIndicator(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    override func prepareForReuse() {
        spinIndicator(true)
        imageView.image = nil
    }
    
    // MARK: Methods
    func configure(with image: GalleryApp_Models.Image) {
        viewModel.set(image)
    }
}

// MARK: - BindableView
extension ImageCollectionViewCell: BindableView {
    func bind(to viewModel: any ViewModel) {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    setDefaultImageWhenFailed()
                }
            }, receiveValue: { [unowned self] image in
                isFavoriteButton.tintColor = image.isFavorite ? .systemRed : .white
                imageView.kf.setImage(with: image.sizeURL.small) { [weak self] _ in
                    guard let self else { return }
                    self.spinIndicator(false)
                }
            })
            .store(in: &subscriptions)
    }
}

// MARK: - Private
private extension ImageCollectionViewCell {
    @objc private func toggleFavorite() {
        viewModel.toggleIsFavorite()
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
    
    func setDefaultImageWhenFailed() {
        let warningImage = UIImage(systemName: Consts.warningImageName)
        imageView.image = warningImage
        imageView.tintColor = .black
    }
}

// MARK: - Consts
private extension ImageCollectionViewCell {
    enum Consts {
        static let heartImageName = "heart.fill"
        static let warningImageName = "exclamationmark.triangle.fill"
    }
}
