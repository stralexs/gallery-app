//
//  ImageDescriptionContainer.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import Factory

// MARK: - ImageDescriptionContainer
final class ImageDescriptionContainer: SharedContainer {
    
    // MARK: Static
    static let shared = ImageDescriptionContainer(manager: .init())
    
    // MARK: Properties
    let manager: ContainerManager
    
    // MARK: Initializer
    private init(manager: ContainerManager) {
        self.manager = manager
    }
}

// MARK: - Services
extension ImageDescriptionContainer {
    var getImagesUseCase: Factory<(any GetImagesUseCase)> {
        self { DefaultGetImagesUseCase() }
    }
    
    var imageDescriptionViewModel: Factory<(any ImageDescriptionViewModel)> {
        self { DefaultImageDescriptionViewModel() }
    }
    
    var imageDescriptionRepository: Factory<ImageDescriptionRepository> {
        self { DefaultImageDescriptionRepository() }
    }
    
    var imageDescriptionDataSource: Factory<ImageDescriptionDataSource> {
        self { DefaultImageDescriptionDataSource() }
    }
    
    var getImagesDTOToDomainMapper: Factory<GetImagesDTOToDomainMapper> {
        self { GetImagesDTOToDomainMapper() }
    }
}
