//
//  DefaultGalleryFeaturesDataSource.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Moya
import Factory
import Combine
import GalleryApp_Models
import GalleryApp_Network
import GalleryApp_CoreData

// MARK: - DefaultGalleryFeaturesDataSource
final class DefaultGalleryFeaturesDataSource {
    
    // MARK: Injected
    @LazyInjected(\.networkManager)
    private var networkManager: NetworkManagerInterface
    
    @LazyInjected(\.coreDataManager)
    private var coreDataManager: CoreDataManagerInterface
}

// MARK: - GalleryFeaturesDataSource
extension DefaultGalleryFeaturesDataSource: GalleryFeaturesDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError> {
        networkManager.request(GetImagesRequest(requestTarget: GetImagesTarget.getImages(page: requestDTO)))
    }
    
    func getFavorites() -> AnyPublisher<[FavoriteImage], CoreDataError> {
        coreDataManager.fetchEntity(FavoriteImage.self)
    }
    
    func addToFavorites(requestDTO: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError> {
        let _ = FavoriteImage(
            id: requestDTO.id,
            fullSizeURLString: requestDTO.sizeURL.full.absoluteString,
            context: coreDataManager.viewContext
        )
        return coreDataManager.saveContext()
            .eraseToAnyPublisher()
    }
    
    func removeFromFavorites(requestDTO: FavoriteImage) -> AnyPublisher<Void, CoreDataError> {
        coreDataManager.deleteEntity(requestDTO)
    }
}
