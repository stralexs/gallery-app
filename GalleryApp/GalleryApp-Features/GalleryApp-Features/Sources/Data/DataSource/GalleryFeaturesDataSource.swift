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
    func addToFavorites(requestDTO: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError>
    func removeFromFavorites(requestDTO: FavoriteImage) -> AnyPublisher<Void, CoreDataError>
}
