//
//  GalleryFeaturesDataSource.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Combine
import Moya

// MARK: - GalleryFeaturesDataSource
protocol GalleryFeaturesDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError>
}
