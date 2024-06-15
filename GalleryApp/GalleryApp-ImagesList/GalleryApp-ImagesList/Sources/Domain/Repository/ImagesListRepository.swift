//
//  ImagesListRepository.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Moya
import Combine
import GalleryApp_Models

// MARK: - ImagesListRepository
protocol ImagesListRepository {
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError>
}
