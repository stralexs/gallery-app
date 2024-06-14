//
//  ImagesListViewController.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models

// TODO: Remove public when navigation is ready (viewModel protocols too)

// MARK: - ImagesListViewController
public final class ImagesListViewController: UICollectionViewController, ViewController {
    
    // MARK: Typealias
    public typealias ViewModel = ImagesListViewModel
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.imagesListViewModel)
    private var viewModel: any ViewModel
        
    // MARK: Properties
    private(set) public var subscriptions: Set<AnyCancellable> = []
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, GalleryApp_Models.Image> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, GalleryApp_Models.Image>(collectionView: collectionView
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
    
    // MARK: Initializer
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Consts.collectionViewSpacing
        layout.minimumInteritemSpacing = Consts.collectionViewSpacing
        let collectionViewWidth = UIScreen.main.bounds.width
        let cellWidth = (collectionViewWidth - 2) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        super.init(collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle
public extension ImagesListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.getImages()
    }
}

// MARK: - Bind
public extension ImagesListViewController {
    func bind(to viewModel: any ViewModel) {
        viewModel.images
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] images in
                var snapshot = NSDiffableDataSourceSnapshot<Int, GalleryApp_Models.Image>()
                snapshot.appendSections([.zero])
                snapshot.appendItems(images)
                diffableDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Consts
private extension ImagesListViewController {
    enum Consts {
        static let collectionViewSpacing: CGFloat = 1
    }
}
