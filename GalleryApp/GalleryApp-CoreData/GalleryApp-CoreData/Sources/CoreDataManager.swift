//
//  CoreDataManager.swift
//  GalleryApp-CoreData
//
//  Created by Alexander Sivko on 16.06.24.
//

import CoreData
import GalleryApp_Models
import GalleryApp_Core

// MARK: - CoreDataManager
public final class CoreDataManager {
    
    // MARK: Properties
    private let persistentContainer: NSPersistentContainer = {
        guard
              let modelURL = Bundle.galleryModels.url(forResource: Consts.gallerAppModel, withExtension: Consts.modelExtension),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load the persistent container for the gallery app model")
        }
        
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
extension CoreDataManager: CoreDataManagerProtocol {
    public func saveContext() {
        viewContext.performAndWait {
            guard self.viewContext.hasChanges else { return }
            do {
                try self.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> Result<[T], CoreDataError> {
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
            return .failure(.requestConversionError)
        }
        
        do {
            let results = try viewContext.fetch(request)
            return .success(results)
        } catch {
            print("Failed to fetch \(entity) objects: \(error)")
            return .failure(.fetchExecutionError)
        }
    }
    
    public func deleteAllData() {
        let entities = persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? .empty)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try viewContext.execute(deleteRequest)
                try viewContext.save()
            } catch {
                print("Error deleting \(entity.name!) objects: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Consts
private extension CoreDataManager {
    enum Consts {
        static let gallerAppModel = "GalleryApp"
        static let modelExtension = "momd"
    }
}

