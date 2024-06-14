//
//  ImagesListViewController.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import Combine
import Factory
import SnapKit
import GalleryApp_Core
import GalleryApp_Models

// TODO: Remove public when navigation is ready (viewModel protocols too)

// MARK: - ImagesListViewController
public final class ImagesListViewController: UIViewController, ViewController {
    
    // MARK: Typealias
    public typealias ViewModel = ImagesListViewModel
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.imagesListViewModel)
    private var viewModel: any ViewModel
        
    // MARK: Properties
    private(set) public var subscriptions: Set<AnyCancellable> = []
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Consts.collectionViewSpacing
        layout.minimumInteritemSpacing = Consts.collectionViewSpacing
        let collectionViewWidth = UIScreen.main.bounds.width
        let cellWidth = (collectionViewWidth - 2) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.className)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, GalleryApp_Models.Image> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, GalleryApp_Models.Image>(collectionView: imagesCollectionView
        ) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.className,
                for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: model.sizeURL.small)
            return cell
        }
        return dataSource
    }()
}

// MARK: - Lifecycle
public extension ImagesListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.getImages()
        setUpHierarchy()
        setUpConstraints()
    }
}

// MARK: - Bind
public extension ImagesListViewController {
    func bind(to viewModel: any ViewModel) {
        viewModel.images
            .sink { [unowned self] images in
                var snapshot = NSDiffableDataSourceSnapshot<Int, GalleryApp_Models.Image>()
                snapshot.appendSections([.zero])
                snapshot.appendItems(images)
                diffableDataSource.apply(snapshot)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private
private extension ImagesListViewController {
    func setUpHierarchy() {
        view.addSubview(imagesCollectionView)
        view.backgroundColor = .white
    }
    
    func setUpConstraints() {
        imagesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Consts
private extension ImagesListViewController {
    enum Consts {
        static let collectionViewSpacing: CGFloat = 1
        static let imageItemSize = CGSize(width: 120, height: 120)
    }
}
