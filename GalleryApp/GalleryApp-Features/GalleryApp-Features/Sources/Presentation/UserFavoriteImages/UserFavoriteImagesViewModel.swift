//
//  UserFavoriteImagesViewModel.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 18.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - Input
public protocol UserFavoriteImagesViewModelInput: ViewModelInput {}

// MARK: - Output
public protocol UserFavoriteImagesViewModelOutput: ViewModelOutput {
    var output: AnyPublisher<LoadingState<[URL]>, Never> { get }
}

// MARK: - UserFavoriteImagesViewModel
public typealias UserFavoriteImagesViewModel = Subscriptionable & UserFavoriteImagesViewModelInput & UserFavoriteImagesViewModelOutput


// MARK: - DefaultUserFavoriteImagesViewModel
final class DefaultUserFavoriteImagesViewModel: UserFavoriteImagesViewModel {
    
    // MARK: Injected
    @LazyInjected(\.galleryFeaturesContainer.getUserFavoriteImagesUseCase)
    private var getUserFavoriteImagesUseCase: any GetUserFavoriteImagesUseCase
    
    // MARK: Publishers
    private let imagesSubject = CurrentValueSubject<LoadingState<[URL]>, Never>(.loaded([]))
    var output: AnyPublisher<LoadingState<[URL]>, Never> { imagesSubject.eraseToAnyPublisher() }
    
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
}

// MARK: - Input
extension DefaultUserFavoriteImagesViewModel {
    func onViewDidLoad() {
        getUserFavoriteImagesUseCase
            .execute(request: ())
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    imagesSubject.send(.failed)
                }
            } receiveValue: { [unowned self] favorites in
                let urls = favorites.map { $0.fullSizeURLString.toURL() }
                imagesSubject.send(.loaded(urls))
            }
            .store(in: &subscriptions)
    }
}
