//
//  UserFavoriteImagesViewController.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import UIKit
import Factory
import Combine
import GalleryApp_Core
import GalleryApp_Navigation

// MARK: - UserFavoriteImagesViewController
final class UserFavoriteImagesViewController: UITableViewController {
    
    // MARK: Typealias
    typealias ViewModel = UserFavoriteImagesViewModel
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.userFavoriteImagesViewModel)
    private var viewModel: any UserFavoriteImagesViewModel
        
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
    private let errorView = ErrorView()
    
    private lazy var diffableDataSource: UITableViewDiffableDataSource<Int, URL> = {
        UITableViewDiffableDataSource<Int, URL>(tableView: tableView
        ) { tableView, indexPath, imageUrl -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UserFavoriteImageTableViewCell.className,
                for: indexPath) as? UserFavoriteImageTableViewCell
            else { return UITableViewCell() }
            cell.configure(with: imageUrl)
            return cell
        }
    }()
}

// MARK: - Lifecycle
extension UserFavoriteImagesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppearance()
        viewModel.onViewDidLoad()
        bind(to: viewModel)
    }
}

// MARK: - BindableView
extension UserFavoriteImagesViewController: BindableView {
    func bind(to viewModel: any ViewModel) {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] loadingState in
                switch loadingState {
                case .loaded(let urls):
                    showTableView()
                    var snapshot = NSDiffableDataSourceSnapshot<Int, URL>()
                    snapshot.appendSections([.zero])
                    snapshot.appendItems(urls)
                    diffableDataSource.apply(snapshot, animatingDifferences: true)
                case .failed:
                    showErrorView()
                case .loading:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITableViewDelegate
extension UserFavoriteImagesViewController {
    override func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return false
    }
}

// MARK: - Private
private extension UserFavoriteImagesViewController {
    func showTableView() {
        tableView.isHidden = false
        errorView.isHidden = true
    }
    
    func showErrorView() {
        tableView.isHidden = true
        errorView.isHidden = false
        errorView.retryAction = { [weak self] in
            guard let self else { return }
            self.viewModel.onViewDidLoad()
        }
    }
    
    func setUpAppearance() {
        tableView.register(UserFavoriteImageTableViewCell.self, forCellReuseIdentifier: UserFavoriteImageTableViewCell.className)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        guard let navigationController = navigationController as? GalleryNavigationController
        else { return }
        navigationController.setNavigationTitle(Consts.navigationTitle)
    }
}

// MARK: - Consts
private extension UserFavoriteImagesViewController {
    enum Consts {
        static let navigationTitle = "Favorite Images"
        static let backButtonItemTitile = "Back"
        static let collectionViewSpacing: CGFloat = 1
        static let collectionViewFooterHeight: CGFloat = 100
    }
}

