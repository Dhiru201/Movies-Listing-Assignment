//
//  PersistentStorage.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import Foundation
import CoreData

final class PersistentStorage {
    /// Private initializer to prevent creating instances of this class.
    private init() {}
    
    /// Shared instance of PersistentStorage.
    static let shared = PersistentStorage()
    
    /// The persistent container for the Core Data stack.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movies_Listing_Assignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// The managed object context associated with the persistent container.
    lazy var context = persistentContainer.viewContext
    
    /// Saves changes to the managed object context.
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Fetches managed objects of a specified type.
    /// - Parameters:
    ///   - managedObject: The type of the managed object to fetch.
    /// - Returns: An array of fetched managed objects of the specified type, or nil if an error occurs.
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else { return nil }
            return result
        }catch let error{
            debugPrint(error)
        }
        return nil
    }
}
