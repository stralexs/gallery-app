//
//  StubImagesListViewModel.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - StubImagesListViewModel
final class StubImagesListViewModel: ImagesListViewModel {
    
    // MARK: Properties
    private let imagesSubject = CurrentValueSubject<LoadingState<[GalleryApp_Models.Image]>, Never>(.loading)
    private let isLoadingMoreDataSubject = CurrentValueSubject<Bool, Never>(false)
    var output: AnyPublisher<LoadingState<[GalleryApp_Models.Image]>, Never> { imagesSubject.eraseToAnyPublisher() }
    var isLoadingMoreData: AnyPublisher<Bool, Never> { isLoadingMoreDataSubject.eraseToAnyPublisher() }
    var subscriptions: Set<AnyCancellable> = []
    var delegate: ImagesListCoordinatorInterface?
    
    // MARK: Methods
    func getMoreImages() {}
    func navigateToImageDescription(selectedImage: Int) {}
    func navigateToUserFavoriteImages() {}
    
    func mockImageLoad(_ images: [GalleryApp_Models.Image]) {
        imagesSubject.send(.loaded(images))
    }
    
    func mockLoadingFailure() {
        imagesSubject.send(.failed)
    }
}
