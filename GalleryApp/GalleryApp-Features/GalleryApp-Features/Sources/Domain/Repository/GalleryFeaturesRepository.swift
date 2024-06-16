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
    func getFavorites() -> AnyPublisher<[GalleryApp_Models.Image], CoreDataError>
}
