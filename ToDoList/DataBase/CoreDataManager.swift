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
       
        let container = NSPersistentContainer(name: "TaskCoreData")
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
        let result = try? viewContext.fetch(assignmentFetchRequest).sorted(by: { first, second in
            return first.id < second.id
        })
        
        return result ?? []
    }
    
    func delete(assignment: Assignment) {
        viewContext.delete(assignment)
        saveContext()
    }
    func addNewTask(title: String, description: String) {
        let newTask = Assignment(context: viewContext)
        newTask.id = Int64(Date().timeIntervalSince1970)
        newTask.title = title
        newTask.discriptiontitle = description
        newTask.isTaskDone = false
        newTask.dateOfCreating = Date()
        
        saveContext()
    }
}

