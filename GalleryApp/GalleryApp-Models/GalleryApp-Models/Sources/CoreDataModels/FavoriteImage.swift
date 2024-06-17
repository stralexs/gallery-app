//
//  FavoriteImage.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 16.06.24.
//
//

import CoreData

// MARK: - FavoriteImage
public final class FavoriteImage: NSManagedObject, Identifiable {
    
    // MARK: Properties
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var fullSizeURLString: String
    
    // MARK: Initializer
    public init(
        id: String,
        fullSizeURLString: String,
        context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: Consts.entityName, in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.fullSizeURLString = fullSizeURLString
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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteImage> {
        return NSFetchRequest<FavoriteImage>(entityName: Consts.entityName)
    }
}

// MARK: - Consts
private extension FavoriteImage {
    enum Consts {
        static let entityName = "ImageSize"
    }
}
