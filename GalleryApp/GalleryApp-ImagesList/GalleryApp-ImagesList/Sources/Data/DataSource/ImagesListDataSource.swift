//
//  ImagesListDataSource.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Combine
import Moya

// MARK: - ImagesListDataSource
protocol ImagesListDataSource {
    func getImages() -> AnyPublisher<GetImagesRequest.ResponseType, MoyaError>
}
