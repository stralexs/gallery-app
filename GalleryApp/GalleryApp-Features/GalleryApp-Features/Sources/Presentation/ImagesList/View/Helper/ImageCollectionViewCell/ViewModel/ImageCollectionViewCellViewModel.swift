//
//  ImageCollectionViewCellViewModel.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 16.06.24.
//

import Combine
import Factory
import GalleryApp_Core
import GalleryApp_Models
import GalleryApp_CoreData

// MARK: - Input
public protocol ImageCollectionViewCellViewModelInput: ViewModelInput {
    func set(_ image: GalleryApp_Models.Image)
    func toggleIsFavorite()
}

// MARK: - Output
public protocol ImageCollectionViewCellViewModelOutput: ViewModelOutput {
    
}

// MARK: - ImageCollectionViewCellViewModel
public typealias ImageCollectionViewCellViewModel = Subscriptionable & ImageCollectionViewCellViewModelInput & ImageCollectionViewCellViewModelOutput


// MARK: - DefaultImageCollectionViewCellViewModel
final class DefaultImageCollectionViewCellViewModel: ImageCollectionViewCellViewModel {
    
    // MARK: Injected
    @LazyInjected(\.coreDataManager)
    private var coreDataManager: CoreDataManagerProtocol
    
    // MARK: Properties
    private(set) var subscriptions: Set<AnyCancellable> = []
    private var image: GalleryApp_Models.Image?
}

// MARK: - Input
extension DefaultImageCollectionViewCellViewModel {
    func set(_ image: GalleryApp_Models.Image) {
        
    }
    
    func toggleIsFavorite() {
//        let error = coreDataManager.deleteAllData()
//        guard let image else { return }
//        image.isFavorite.toggle()
//        if image.isFavorite {
//            coreDataManager.deleteAllData()
//            coreDataManager.saveContext()
//        }
    }
}
