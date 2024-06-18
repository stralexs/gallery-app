//
//  CoreDataManagerInterface.swift
//  GalleryApp-CoreData
//
//  Created by Alexander Sivko on 16.06.24.
//

import Combine
import CoreData
import GalleryApp_Models

// MARK: - CoreDataManagerInterface
public protocol CoreDataManagerInterface {
    var viewContext: NSManagedObjectContext { get }
    func saveContext() -> AnyPublisher<Void, CoreDataError>
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> AnyPublisher<[T], CoreDataError>
    func deleteEntity<T: NSManagedObject>(_ entity: T) -> AnyPublisher<Void, CoreDataError>
}
