//
//  ImagesListViewModel.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models
import Moya

// MARK: - Input
protocol ImagesListViewModelInput: ViewModelInput {
    var delegate: ImagesListCoordinatorInterface? { get set }
    func getImages()
    func getMoreImages()
    func navigateToImageDescription(selectedImage: Int)
}

// MARK: - Output
protocol ImagesListViewModelOutput: ViewModelOutput {
    var images: AnyPublisher<LoadingState<[GalleryApp_Models.Image]>, Never> { get }
    var isLoadingMoreData: AnyPublisher<Bool, Never> { get }
}

// MARK: - ImagesListViewModel
typealias ImagesListViewModel = Subscriptionable & ImagesListViewModelInput & ImagesListViewModelOutput

// MARK: - DefaultImagesListViewModel
final class DefaultImagesListViewModel: ImagesListViewModel {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.getImagesUseCase)
    private var getImagesUseCase: any GetImagesUseCase
    
    @LazyInjected(\.galleryFeaturesContainer.getUserFavoriteImagesUseCase)
    private var getUserFavoriteImagesUseCase: any GetUserFavoriteImagesUseCase
    
    // MARK: Publishers
    private let imagesSubject = CurrentValueSubject<LoadingState<[GalleryApp_Models.Image]>, Never>(.loading)
    private let isLoadingMoreDataSubject = CurrentValueSubject<Bool, Never>(false)
    var images: AnyPublisher<LoadingState<[GalleryApp_Models.Image]>, Never> { imagesSubject.eraseToAnyPublisher() }
    var isLoadingMoreData: AnyPublisher<Bool, Never> { isLoadingMoreDataSubject.eraseToAnyPublisher() }
    
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var pagesCounter: Int = 1
    private var favoriteImagesIDs: Set<String> = []
    weak var delegate: ImagesListCoordinatorInterface?
}

// MARK: - Input
extension DefaultImagesListViewModel {
    func getImages() {
        imagesSubject.send(.loading)
        getUserFavoriteImagesUseCase
            .execute(request: ())
            .mapError { error in
                MoyaError.underlying(error, nil)
            }
            .flatMap { [unowned self] favorites -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> in
                favoriteImagesIDs = Set(favorites.map { $0.id })
                return getImagesUseCase.execute(request: pagesCounter)
            }
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    imagesSubject.send(.failed)
                }
            } receiveValue: { [unowned self] images in
                let mappedImages = mapFavorites(through: images)
                self.imagesSubject.send(.loaded(mappedImages))
            }
            .store(in: &subscriptions)
    }
    
    func getMoreImages() {
        guard !isLoadingMoreDataSubject.value else { return }
        pagesCounter += 1
        isLoadingMoreDataSubject.send(true)
        getUserFavoriteImagesUseCase
            .execute(request: ())
            .mapError { error in
                MoyaError.underlying(error, nil)
            }
            .flatMap { [unowned self] favorites -> AnyPublisher<[GalleryApp_Models.Image], MoyaError> in
                favoriteImagesIDs = Set(favorites.map { $0.id })
                return getImagesUseCase.execute(request: pagesCounter)
            }
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    imagesSubject.send(.failed)
                    isLoadingMoreDataSubject.send(false)
                }
            } receiveValue: { [unowned self] images in
                if case var .loaded(currentImages) = imagesSubject.value {
                    let existingIds = Set(currentImages.map { $0.id })
                    let filteredImages = images.filter { !existingIds.contains($0.id) }
                    currentImages.append(contentsOf: filteredImages)
                    let mappedImages = mapFavorites(through: currentImages)
                    imagesSubject.send(.loaded(mappedImages))
                }
                isLoadingMoreDataSubject.send(false)
            }
            .store(in: &subscriptions)
    }
    
    func navigateToImageDescription(selectedImage: Int) {
        if case let .loaded(images) = imagesSubject.value {
            delegate?.navigateToImageDescription(images: images, selectedImage: selectedImage)
        }
    }
}

// MARK: - Private
private extension DefaultImagesListViewModel {
    func mapFavorites(through images: [GalleryApp_Models.Image]) -> [GalleryApp_Models.Image] {
        images.map { image in
            var toggledImage = image
            if favoriteImagesIDs.contains(image.id) {
                toggledImage.toggleIsFavorite()
            }
            return toggledImage
        }
    }
}
