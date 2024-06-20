//
//  GetImagesDTOToDomainMapper.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import Factory
import GalleryApp_Core
import GalleryApp_Models

// MARK: - GetImagesDTOToDomainMapper
final class GetImagesDTOToDomainMapper: Mapper {
    func mapModel(_ model: [ImageDTO]) -> [GalleryApp_Models.Image] {
        model.map {
            GalleryApp_Models.Image(
                id: $0.id,
                description: $0.altDescription ?? .empty,
                createdAt: formatDate($0.createdAt),
                creatorName: $0.user.name,
                sizeURL: ImageSizeURL(
                    small: $0.urls.small,
                    full:$0.urls.full),
                isFavorite: false
            )
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
