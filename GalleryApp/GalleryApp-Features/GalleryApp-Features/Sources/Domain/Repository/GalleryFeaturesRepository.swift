//
//  GalleryFeaturesRepository.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Moya
import Combine
import GalleryApp_Models

// MARK: - GalleryFeaturesRepository
protocol GalleryFeaturesRepository {
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError>
    func getFavorites() -> AnyPublisher<[FavoriteImage], CoreDataError>
    func addToFavorites(requestDTO: GalleryApp_Models.Image) -> AnyPublisher<Void, CoreDataError>
    func removeFromFavorites(requestDTO: FavoriteImage) -> AnyPublisher<Void, CoreDataError>
}
