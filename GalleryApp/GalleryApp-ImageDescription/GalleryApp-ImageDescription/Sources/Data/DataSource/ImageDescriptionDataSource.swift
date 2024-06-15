//
//  ImageDescriptionDataSource.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import Combine
import Moya

// MARK: - ImageDescriptionDataSource
protocol ImageDescriptionDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError>
}
