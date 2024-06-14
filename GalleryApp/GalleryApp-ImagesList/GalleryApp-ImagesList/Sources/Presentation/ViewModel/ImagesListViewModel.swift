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
}

// MARK: - Output
public protocol ImagesListViewModelOutput: ViewModelOutput {
    var images: AnyPublisher<[GalleryApp_Models.Image], Never> { get }
}

// MARK: - ImagesListViewModel
public typealias ImagesListViewModel = Subscriptionable & ImagesListViewModelInput & ImagesListViewModelOutput

// MARK: - DefaultImagesListViewModel
final class DefaultImagesListViewModel: ImagesListViewModel {
    
    // MARK: Injected
    @LazyInjected(\.imagesListContainer.getImagesUseCase)
    private var getImagesUseCase: any GetImagesUseCase
    
    // MARK: Publishers
    private let imagesSubject = PassthroughSubject<[GalleryApp_Models.Image], Never>()
    
    var images: AnyPublisher<[GalleryApp_Models.Image], Never> { imagesSubject.eraseToAnyPublisher() }
    
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
}

// MARK: - Input
extension DefaultImagesListViewModel {
    func getImages() {
        getImagesUseCase
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print()
                case .failure:
                    print()
                }
            } receiveValue: { _ in
                
            }
            .store(in: &subscriptions)
    }
}
