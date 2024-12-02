//
//  DataBaseManager.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import Foundation
import UIKit

class DataBaseManager {
    var dataSource: [Task] = []

    func getAllTasks() -> [Task] {
        return dataSource
    }
    
    func removeTask(at index: Int) {
        dataSource.remove(at: index)
    }
    
    func update(task: Task) {
        guard let index = dataSource.firstIndex(where: { $0.id == task.id }) else { return }
        dataSource.remove(at: index)
        dataSource.insert(task, at: index)
    }
    
    func insert(task: Task, at index: Int) {
        dataSource.insert(task, at: index)
    }
}
