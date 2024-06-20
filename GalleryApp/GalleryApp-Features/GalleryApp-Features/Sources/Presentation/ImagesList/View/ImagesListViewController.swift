//
//  ImagesListViewController.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import Combine
import Factory
import SnapKit
import GalleryApp_Core
import GalleryApp_Models
import GalleryApp_Navigation

// MARK: - ImagesListViewController
final class ImagesListViewController: UICollectionViewController {
    
    // MARK: Typealias
    typealias ViewModel = ImagesListViewModel
        
    // MARK: Properties
    private let viewModel: any ImagesListViewModel
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var isFetchingImages = false
    private var isFirstAppear = false
    private var lastContentOffset: CGPoint = .zero
    
    private let loadingView = LoadingView()
    private let errorView = ErrorView()
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, GalleryApp_Models.Image> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, GalleryApp_Models.Image>(collectionView: collectionView
        ) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.className,
                for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: model)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
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
    init(viewModel: any ImagesListViewModel) {
        self.viewModel = viewModel
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
extension ImagesListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarchy()
        setUpConstraints()
        bind(to: viewModel)
        viewModel.onViewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        setUpAppearance()
        viewModel.onViewIsAppearing()
        isFirstAppear.toggle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstAppear.toggle()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveContentOffset()
    }
}

// MARK: - BindableView
extension ImagesListViewController: BindableView {
    func bind(to viewModel: any ViewModel) {
        viewModel.output
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
                    diffableDataSource.apply(snapshot, animatingDifferences: false)
                    if isFirstAppear { collectionView.setContentOffset(lastContentOffset, animated: false) }
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

// MARK: - UICollectionViewDelegate
extension ImagesListViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.navigateToImageDescription(selectedImage: indexPath.row)
    }
}

// MARK: - UIScrollViewDelegate
extension ImagesListViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let isPortrait = traitCollection.verticalSizeClass == .regular
        let numberOfItemsPerRow: CGFloat = isPortrait ? 3 : 5
        let spacing = Consts.collectionViewSpacing * (numberOfItemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - spacing
        let width = availableWidth / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        isFetchingImages ? CGSize(width: collectionView.bounds.width, height: Consts.collectionViewFooterHeight) : .zero
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
            self.viewModel.onViewDidLoad()
        }
    }
    
    func setUpAppearance() {
        guard let navigationController = navigationController as? GalleryNavigationController 
        else { return }
        navigationController.setNavigationTitle(Consts.navigationTitle)
        navigationController.setBackButtonTitle(Consts.backButtonItemTitile)
        navigationController.addRightNavigationItem(target: self, action: #selector(rightButtonTapped))
    }
    
    @objc func rightButtonTapped() {
        viewModel.navigateToUserFavoriteImages()
    }
    
    func saveContentOffset() {
        lastContentOffset = collectionView.contentOffset
    }
}

// MARK: - Consts
private extension ImagesListViewController {
    enum Consts {
        static let navigationTitle = "Gallery App"
        static let backButtonItemTitile = "Back"
        static let collectionViewSpacing: CGFloat = 1
        static let collectionViewFooterHeight: CGFloat = 100
    }
}
