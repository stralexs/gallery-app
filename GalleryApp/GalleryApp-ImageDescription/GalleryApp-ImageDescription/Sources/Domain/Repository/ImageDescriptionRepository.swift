//
//  ImageDescriptionRepository.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import Moya
import Combine
import GalleryApp_Models

// MARK: - ImageDescriptionRepository
protocol ImageDescriptionRepository {
    func getImages(requestDTO: Int) -> AnyPublisher<[GalleryApp_Models.Image], MoyaError>
}
