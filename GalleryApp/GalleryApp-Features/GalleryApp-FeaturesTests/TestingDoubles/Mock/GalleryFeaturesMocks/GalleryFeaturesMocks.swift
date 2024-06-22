//
//  GalleryFeaturesMocks.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Moya
import Factory
import Combine
import GalleryApp_Models
import GalleryApp_CoreData

@testable import GalleryApp_Features

// MARK: - GalleryFeaturesMocks
enum GalleryFeaturesMocks {
    static let togglingFavoriteResponse: Void = ()
    static let networkError: MoyaError = .statusCode(.init(statusCode: 400, data: Data()))
    static let coreDataError: CoreDataError = .fetchExecutionError
    static let getImagesResponseDTO: [ImageDTO] = [
        .init(
            id: "Foo",
            altDescription: "Bar",
            createdAt: "Baz",
            user: .init(name: "Foo"),
            urls: .init(small: "Bar", full: "Baz")
        ),
        .init(
            id: "Foo",
            altDescription: "Bar",
            createdAt: "Baz",
            user: .init(name: "Foo"),
            urls: .init(small: "Bar", full: "Baz")
        )
    ]
    static let getImagesResponse: [GalleryApp_Models.Image] = [
        .init(
            id: "Foo",
            description: "Bar",
            createdAt: "Baz",
            creatorName: "Foo",
            sizeURL: .init(small: "Bar", full: "Baz"),
            isFavorite: true
        ),
        .init(
            id: "Foo",
            description: "Bar",
            createdAt: "Baz",
            creatorName: "Foo",
            sizeURL: .init(small: "Bar", full: "Baz"),
            isFavorite: true
        )
    ]
    static let getFavoritesResponse: [FavoriteImage] = [
        .init(
            id: "Foo",
            fullSizeURLString: "Bar",
            context: Container.shared.coreDataManager.resolve().viewContext
        ),
        .init(
            id: "Foo",
            fullSizeURLString: "Bar",
            context: Container.shared.coreDataManager.resolve().viewContext
        )
    ]
    static let requestImage: GalleryApp_Models.Image = .init(
        id: "Foo",
        description: "Bar",
        createdAt: "Baz",
        creatorName: "Foo",
        sizeURL: .init(small: "Bar", full: "Baz"),
        isFavorite: false
    )
    static let requestFavoriteImage: FavoriteImage = .init(
        id: "Foo",
        fullSizeURLString: "Bar",
        context: Container.shared.coreDataManager.resolve().viewContext
    )
}
