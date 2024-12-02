//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 02.12.2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: NSObject {

    public static let shared = CoreDataManager()
    
    private override init() {}
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func obtainSavedData() -> [Assignment] {
        let assignmentFetchRequest = Assignment.fetchRequest()
        let result = try? viewContext.fetch(assignmentFetchRequest)
        
        return result ?? []
    }
}

