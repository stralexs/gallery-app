//
//  ImageSize.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 16.06.24.
//
//

import CoreData

// MARK: - ImageSize
public class ImageSize: NSManagedObject, Identifiable {
    
    // MARK: Properties
    @NSManaged public private(set) var full: String
    @NSManaged public private(set) var small: String
    @NSManaged public var image: Image?
    
    // MARK: Initializer
    public init(
        full: String,
        small: String,
        image: Image? = nil,
        context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: Consts.entityName, in: context)!
        super.init(entity: entity, insertInto: context)
        self.full = full
        self.small = small
        self.image = image
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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageSize> {
        return NSFetchRequest<ImageSize>(entityName: Consts.entityName)
    }
}

// MARK: - Consts
private extension ImageSize {
    enum Consts {
        static let entityName = "ImageSize"
    }
}
