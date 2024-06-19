//
//  AddToFavoritesDomainToDTOMapper.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 19.06.24.
//

import Factory
import GalleryApp_Core
import GalleryApp_Models
import GalleryApp_CoreData

// MARK: - AddToFavoritesDomainToDTOMapper
final class AddToFavoritesDomainToDTOMapper {
    
    // MARK: Injected
    @LazyInjected(\.coreDataManager)
    private var coreDataManager: CoreDataManagerInterface
}

// MARK: - Mapper
extension AddToFavoritesDomainToDTOMapper: Mapper {
    func mapModel(_ model: GalleryApp_Models.Image) -> FavoriteImage {
        FavoriteImage(
            id: model.id,
            fullSizeURLString: model.sizeURL.full.absoluteString,
            context: coreDataManager.viewContext
        )
    }
}
