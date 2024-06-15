//
//  ImagesListViewModel.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - Input
public protocol ImagesListViewModelInput: ViewModelInput {
    func getImages()
    func getMoreImages()
}

// MARK: - Output
public protocol ImagesListViewModelOutput: ViewModelOutput {
    var images: AnyPublisher<LoadingState<[GalleryApp_Models.Image]>, Never> { get }
    var isLoadingMoreData: AnyPublisher<Bool, Never> { get }
}

// MARK: - ImagesListViewModel
public typealias ImagesListViewModel = Subscriptionable & ImagesListViewModelInput & ImagesListViewModelOutput

// MARK: - DefaultImagesListViewModel
final class DefaultImagesListViewModel: ImagesListViewModel {
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.getImagesUseCase)
    private var getImagesUseCase: any GetImagesUseCase
    
    // MARK: Publishers
    private let imagesSubject = CurrentValueSubject<LoadingState<[GalleryApp_Models.Image]>, Never>(.loading)
    private let isLoadingMoreDataSubject = CurrentValueSubject<Bool, Never>(false)
    var images: AnyPublisher<LoadingState<[GalleryApp_Models.Image]>, Never> { imagesSubject.eraseToAnyPublisher() }
    var isLoadingMoreData: AnyPublisher<Bool, Never> { isLoadingMoreDataSubject.eraseToAnyPublisher() }
    
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var pagesCounter: Int = 1
}

// MARK: - Input
extension DefaultImagesListViewModel {
    func getImages() {
        imagesSubject.send(.loading)
        getImagesUseCase
            .execute(request: pagesCounter)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    imagesSubject.send(.failed)
                }
            } receiveValue: { [unowned self] images in
                self.imagesSubject.send(.loaded(images))
            }
            .store(in: &subscriptions)
    }
    
    func getMoreImages() {
        guard !isLoadingMoreDataSubject.value else { return }
        pagesCounter += 1
        isLoadingMoreDataSubject.send(true)
        getImagesUseCase
            .execute(request: pagesCounter)
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
                    imagesSubject.send(.loaded(currentImages))
                }
                isLoadingMoreDataSubject.send(false)
            }
            .store(in: &subscriptions)
    }
}
