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
public final class ImagesListViewController: UICollectionViewController, ViewController {
    
    // MARK: Typealias
    public typealias ViewModel = ImagesListViewModel
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.imagesListViewModel)
    private var viewModel: any ViewModel
        
    // MARK: Properties
    private(set) public var subscriptions: Set<AnyCancellable> = []
    private var isFetchingImages = false
    
    private let loadingView = LoadingView()
    private let errorView = ErrorView()
    
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
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.className,
                for: indexPath
            ) as! LoadingFooterView
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
        collectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.className
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle
public extension ImagesListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarchy()
        setUpConstraints()
        bind(to: viewModel)
        viewModel.getImages()
    }
}

// MARK: - Bind
public extension ImagesListViewController {
    func bind(to viewModel: any ViewModel) {
        viewModel.images
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] loadingState in
                switch loadingState {
                case .loading:
                    showLoadingView()
                case .loaded(let images):
                    showCollectionView()
                    var snapshot = NSDiffableDataSourceSnapshot<Int, GalleryApp_Models.Image>()
                    snapshot.appendSections([.zero])
                    snapshot.appendItems(images)
                    diffableDataSource.apply(snapshot, animatingDifferences: true)
                case .failed:
                    showErrorView()
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        viewModel.isLoadingMoreData
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isLoading in
                isFetchingImages = isLoading
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private
private extension ImagesListViewController {
    func setUpHierarchy() {
        [loadingView, errorView].forEach { view.addSubview($0) }
        loadingView.isHidden = true
        errorView.isHidden = true
    }
    
    func setUpConstraints() {
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showLoadingView() {
        loadingView.isHidden = false
        errorView.isHidden = true
    }
    
    func showCollectionView() {
        collectionView.isHidden = false
        loadingView.isHidden = true
        errorView.isHidden = true
    }
    
    func showErrorView() {
        collectionView.isHidden = true
        loadingView.isHidden = true
        errorView.isHidden = false
        errorView.retryAction = { [weak self] in
            guard let self else { return }
            self.viewModel.getImages()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImagesListViewController {
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > scrollView.bounds.height else { return }
        let position = scrollView.contentOffset.y
        let threshold = collectionView.contentSize.height - Consts.collectionViewFooterHeight - scrollView.frame.size.height
        if position > threshold && !isFetchingImages {
            viewModel.getMoreImages()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        isFetchingImages ? CGSize(width: collectionView.bounds.width, height: Consts.collectionViewFooterHeight) : .zero
    }
}

// MARK: - Consts
private extension ImagesListViewController {
    enum Consts {
        static let collectionViewSpacing: CGFloat = 1
        static let collectionViewFooterHeight: CGFloat = 100
    }
}
