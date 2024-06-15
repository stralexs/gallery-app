//
//  DefaultImagesListDataSource.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory
import Combine
import Moya
import GalleryApp_Network

// MARK: - DefaultImagesListDataSource
final class DefaultImagesListDataSource {
    
    // MARK: Injected
    @LazyInjected(\.networkManager)
    private var networkManager: NetworkManagerProtocol
}

// MARK: - ImagesListDataSource
extension DefaultImagesListDataSource: ImagesListDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError> {
        networkManager.request(GetImagesRequest(requestTarget: GetImagesTarget.getImages(page: requestDTO)))
    }
}
