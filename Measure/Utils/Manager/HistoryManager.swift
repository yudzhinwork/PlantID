//
//  HistoryManager.swift

//
//  Created by  on 10.06.2024.
//
import UIKit
import CoreData

final class HistoryManager {
    
    // MARK: - Singletone
    
    static let shared = HistoryManager()
    
    // MARK: - Life cycle
    
    private init() {}
    
    // MARK: - Properties
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    // MARK: - Public Functions
    
    func createHistoryWith(_ name: String, date: Date, length: Float, comment: String?) {
        let newHistory = History(context: context)
        newHistory.date = date
        newHistory.comment = comment
        
        saveContext()
    }
    
    func fetchAllHistories() -> [History] {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        do {
            let histories = try context.fetch(fetchRequest)
            return histories
        } catch {
            print("Failed to fetch histories: \(error)")
            return []
        }
    }
    
    func deleteHistory(_ history: History) {
        context.delete(history)
        saveContext()
    }
}

// MARK: - Private

private extension HistoryManager {
    
    func saveContext() {
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
