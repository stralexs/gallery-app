//
//  MockCoreDataManager.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import Combine
import CoreData
import GalleryApp_Models
import GalleryApp_CoreData

@testable import GalleryApp_Features

// MARK: - MockCoreDataManager
final class MockCoreDataManager: CoreDataManagerInterface {
    
    // MARK: Properties
    var isPositiveScenario: Bool
    var getFavoritesResponse: [FavoriteImage]
    private let togglingFavoriteResponse: Void
    private let coreDataError: CoreDataError
    var viewContext: NSManagedObjectContext = {
        guard let modelURL = Bundle.galleryModels.url(
            forResource: Consts.gallerAppModel,
            withExtension: Consts.modelExtension),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else { return NSManagedObjectContext(.mainQueue) }
        
        let persistentContainer = NSPersistentContainer(name: Consts.gallerAppModel, managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, _ in }
        return persistentContainer.viewContext
    }()
    
    // MARK: Initializer
    init(
        isPositiveScenario: Bool,
        getFavoritesResponse: [FavoriteImage],
        togglingFavoriteResponse: Void,
        coreDataError: CoreDataError
    ) {
        self.isPositiveScenario = isPositiveScenario
        self.getFavoritesResponse = getFavoritesResponse
        self.togglingFavoriteResponse = togglingFavoriteResponse
        self.coreDataError = coreDataError
    }
    
    // MARK: Methods
    func saveContext() -> AnyPublisher<Void, CoreDataError> {
        if isPositiveScenario {
            return Just(togglingFavoriteResponse)
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> AnyPublisher<[T], CoreDataError> {
        if isPositiveScenario {
            return Just(getFavoritesResponse as! [T])
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
    
    func deleteEntity<T: NSManagedObject>(_ entity: T) -> AnyPublisher<Void, CoreDataError> {
        if isPositiveScenario {
            return Just(togglingFavoriteResponse)
                .setFailureType(to: CoreDataError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: coreDataError)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Consts
private extension MockCoreDataManager {
    enum Consts {
        static let gallerAppModel = "GalleryApp"
        static let modelExtension = "momd"
    }
}
