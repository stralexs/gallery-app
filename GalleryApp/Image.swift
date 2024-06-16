//
//  Image+CoreDataClass.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 16.06.24.
//
//

import CoreData

// MARK: - Image
public final class Image: NSManagedObject, Identifiable {
    
    // MARK: Properties
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var fullDescription: String
    @NSManaged public private(set) var createdAt: String
    @NSManaged public private(set) var creatorName: String
    @NSManaged public private(set) var imageSize: ImageSize
    @NSManaged public var isFavorite: Bool
    
    // MARK: Initializer
    public init(
        id: String,
        fullDescription: String,
        createdAt: String,
        creatorName: String,
        imageSize: ImageSize,
        isFavorite: Bool,
        context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: Consts.entityName, in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.fullDescription = fullDescription
        self.createdAt = createdAt
        self.creatorName = creatorName
        self.imageSize = imageSize
        self.isFavorite = isFavorite
    }
    
    @available(*, unavailable)
    public init() {
        fatalError("\(#function) not implemented")
    }

    @available(*, unavailable)
    public init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }
    
    // MARK: Methods
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: Consts.entityName)
    }
}

// MARK: - Consts
private extension Image {
    enum Consts {
        static let entityName = "Image"
    }
}
