//
//  ImagesListContainer.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory

// MARK: - ImagesListContainer
final class ImagesListContainer: SharedContainer {
    
    // MARK: Static
    static let shared = ImagesListContainer(manager: .init())
    
    // MARK: Properties
    let manager: ContainerManager
    
    // MARK: Initializer
    private init(manager: ContainerManager) {
        self.manager = manager
    }
}

// MARK: - Services
extension ImagesListContainer {
    var getImagesUseCase: Factory<(any GetImagesUseCase)> {
        self { DefaultGetImagesUseCase() }
    }
    
    var imagesListViewModel: Factory<(any ImagesListViewModel)> {
        self { DefaultImagesListViewModel() }
    }
    
    var imagesListRepository: Factory<ImagesListRepository> {
        self { DefaultImagesListRepository() }
    }
    
    var imagesListDataSource: Factory<ImagesListDataSource> {
        self { DefaultImagesListDataSource() }
    }
    
    var getImagesDTOToDomainMapper: Factory<GetImagesDTOToDomainMapper> {
        self { GetImagesDTOToDomainMapper() }
    }
}
