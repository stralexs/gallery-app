//
//  DefaultGalleryFeaturesDataSource.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory
import Combine
import Moya
import GalleryApp_Network

// MARK: - DefaultGalleryFeaturesDataSource
final class DefaultGalleryFeaturesDataSource {
    
    // MARK: Injected
    @LazyInjected(\.networkManager)
    private var networkManager: NetworkManagerProtocol
}

// MARK: - GalleryFeaturesDataSource
extension DefaultGalleryFeaturesDataSource: GalleryFeaturesDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError> {
        networkManager.request(GetImagesRequest(requestTarget: GetImagesTarget.getImages(page: requestDTO)))
    }
}
