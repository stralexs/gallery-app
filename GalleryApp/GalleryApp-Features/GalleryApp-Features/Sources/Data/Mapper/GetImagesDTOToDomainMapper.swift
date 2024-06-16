//
//  GetImagesDTOToDomainMapper.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory
import GalleryApp_Core
import GalleryApp_Models
import GalleryApp_CoreData

// MARK: - GetImagesDTOToDomainMapper
final class GetImagesDTOToDomainMapper {
    
    // MARK: Injected
    @LazyInjected(\.coreDataManager)
    private var coreDataManager: CoreDataManagerProtocol
}

// MARK: - Mapper
extension GetImagesDTOToDomainMapper: Mapper {
    func mapModel(_ model: [ImageDTO]) -> [GalleryApp_Models.Image] {
        model.map { imageDTO in
            let imageSize = ImageSize(
                full: imageDTO.urls.full,
                small: imageDTO.urls.small,
                context: coreDataManager.viewContext
            )
            let image = GalleryApp_Models.Image(
                id: imageDTO.id,
                fullDescription: imageDTO.altDescription,
                createdAt: formatDate(imageDTO.createdAt),
                creatorName: imageDTO.user.name,
                imageSize: imageSize,
                context: coreDataManager.viewContext
            )
            imageSize.image = image
            return image
        }
    }
}

// MARK: - Private
private extension GetImagesDTOToDomainMapper {
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "dd MM yyyy"
        let formattedDateString = dateFormatter.string(from: date)
        
        return formattedDateString
    }
}
