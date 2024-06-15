//
//  DefaultImageDescriptionDataSource.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import Factory
import Combine
import Moya
import GalleryApp_Network

// MARK: - DefaultImageDescriptionDataSource
final class DefaultImageDescriptionDataSource {
    
    // MARK: Injected
    @LazyInjected(\.networkManager)
    private var networkManager: NetworkManagerProtocol
}

// MARK: - ImageDescriptionDataSource
extension DefaultImageDescriptionDataSource: ImageDescriptionDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError> {
        networkManager.request(GetImagesRequest(requestTarget: GetImagesTarget.getImages(page: requestDTO)))
    }
}

