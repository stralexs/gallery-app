//
//  ImageDescriptionViewModel.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 15.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - Input
public protocol ImageDescriptionViewModelInput: ViewModelInput {
    func setImages(_ images: [GalleryApp_Models.Image])
    func getMoreImages()
}

// MARK: - Output
public protocol ImageDescriptionViewModelOutput: ViewModelOutput {
    var images: [GalleryApp_Models.Image] { get }
    var isErrorOccurred: Bool { get }
}

// MARK: - ImageDescriptionViewModel
public typealias ImageDescriptionViewModel = Subscriptionable & ImageDescriptionViewModelInput & ImageDescriptionViewModelOutput & ObservableObject

// MARK: - DefaultImageDescriptionViewModel
final class DefaultImageDescriptionViewModel: ImageDescriptionViewModel {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.getImagesUseCase)
    private var getImagesUseCase: any GetImagesUseCase
    
    // MARK: Properties
    @Published private(set) var images: [Image] = []
    @Published private(set) var isErrorOccurred: Bool = false
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var pagesCounter: Int = 0
}

// MARK: - Input
extension DefaultImageDescriptionViewModel {
    func setImages(_ images: [GalleryApp_Models.Image]) {
        self.images = images
        pagesCounter = images.count / 30
    }
    
    func getMoreImages() {
        pagesCounter += 1
        getImagesUseCase
            .execute(request: pagesCounter)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    isErrorOccurred = true
                }
            } receiveValue: { [unowned self] images in
                self.images.append(contentsOf: images)
            }
            .store(in: &subscriptions)
    }
}
