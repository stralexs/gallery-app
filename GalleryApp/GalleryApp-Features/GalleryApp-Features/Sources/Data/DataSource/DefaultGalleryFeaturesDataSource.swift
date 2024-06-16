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
    private var networkManager: NetworkManagerProtocol
    
    // MARK: Injected
    @LazyInjected(\.coreDataManager)
    private var coreDataManager: CoreDataManagerProtocol
}

// MARK: - GalleryFeaturesDataSource
extension DefaultGalleryFeaturesDataSource: GalleryFeaturesDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError> {
        networkManager.request(GetImagesRequest(requestTarget: GetImagesTarget.getImages(page: requestDTO)))
    }
    
    func getFavorites() -> AnyPublisher<[GalleryApp_Models.Image], CoreDataError> {
        coreDataManager.fetchEntity(GalleryApp_Models.Image.self)
    }
}
