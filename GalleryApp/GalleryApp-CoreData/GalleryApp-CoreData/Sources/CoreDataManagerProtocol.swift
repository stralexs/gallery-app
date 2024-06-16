//
//  CoreDataManagerProtocol.swift
//  GalleryApp-CoreData
//
//  Created by Alexander Sivko on 16.06.24.
//

import CoreData
import GalleryApp_Models

// MARK: - CoreDataManagerProtocol
public protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func saveContext ()
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> Result<[T], CoreDataError>
    func deleteAllData()
}
