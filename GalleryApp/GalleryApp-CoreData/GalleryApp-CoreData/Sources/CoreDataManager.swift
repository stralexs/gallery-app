//
//  CoreDataManager.swift
//  GalleryApp-CoreData
//
//  Created by Alexander Sivko on 16.06.24.
//

import Combine
import CoreData
import GalleryApp_Models
import GalleryApp_Core

// MARK: - CoreDataManager
public final class CoreDataManager {
    
    // MARK: Properties
    private let persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.galleryModels.url(
            forResource: Consts.gallerAppModel,
            withExtension: Consts.modelExtension),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else { fatalError("Failed to load the persistent container for the gallery app model") }
        
        let container = NSPersistentContainer(name: Consts.gallerAppModel, managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: Initializer
    public init() {}
}

// MARK: - CoreDataManagerInterface
extension CoreDataManager: CoreDataManagerInterface {
    public func saveContext() -> AnyPublisher<Void, CoreDataError> {
        Future<Void, CoreDataError> { [weak self] promise in
            guard let self else { promise(.failure(.saveExecutionError)); return }
            viewContext.performAndWait {
                guard self.viewContext.hasChanges else {
                    promise(.success(()))
                    return
                }
                do {
                    try self.viewContext.save()
                    promise(.success(()))
                } catch {
                    print("Failed to save: \(error.localizedDescription)")
                    promise(.failure(.saveExecutionError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> AnyPublisher<[T], CoreDataError> {
        Future<[T], CoreDataError> { [weak self] promise in
            guard let request = T.fetchRequest() as? NSFetchRequest<T>,
                  let self else { promise(.failure(.requestConversionError)); return }
            do {
                let results = try self.viewContext.fetch(request)
                promise(.success(results))
            } catch {
                print("Failed to fetch \(entity) objects: \(error.localizedDescription)")
                promise(.failure(.fetchExecutionError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteEntity<T: NSManagedObject>(_ entity: T) -> AnyPublisher<Void, CoreDataError> {
        Future<Void, CoreDataError> { promise in
            self.viewContext.perform {
                do {
                    self.viewContext.delete(entity)
                    try self.viewContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(.deleteExecutionError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Consts
private extension CoreDataManager {
    enum Consts {
        static let gallerAppModel = "GalleryApp"
        static let modelExtension = "momd"
    }
}

