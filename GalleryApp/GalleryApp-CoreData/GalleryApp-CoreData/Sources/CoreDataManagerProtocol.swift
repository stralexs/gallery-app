//
//  CoreDataManagerProtocol.swift
//  GalleryApp-CoreData
//
//  Created by Alexander Sivko on 16.06.24.
//

import Combine
import CoreData
import GalleryApp_Models

// MARK: - CoreDataManagerProtocol
public protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func saveContext()
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> AnyPublisher<[T], CoreDataError>
    func deleteEntity<T: NSManagedObject>(_ entity: T) -> CoreDataError?
    func deleteAllData() -> CoreDataError?
}
