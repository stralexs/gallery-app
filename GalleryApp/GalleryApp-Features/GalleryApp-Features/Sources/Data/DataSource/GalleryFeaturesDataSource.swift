//
//  GalleryFeaturesDataSource.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Moya
import Combine
import GalleryApp_Models

// MARK: - GalleryFeaturesDataSource
protocol GalleryFeaturesDataSource {
    func getImages(requestDTO: Int) -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError>
    func getFavorites() -> AnyPublisher<[FavoriteImage], CoreDataError>
}
