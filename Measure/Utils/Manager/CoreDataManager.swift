//
//  CoreDataManager.swift

//
//  Created by  on 10.06.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Singletone
    
    static let shared = CoreDataManager()
    
    // MARK: - Life cycle
    
    private init() {}
    
    // MARK: - Properties
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "History")
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Public Functions
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
