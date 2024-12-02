//
//  FetchTasksManager.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 01.12.2024.
//

import UIKit
import Foundation
class FetchTasksManager {
    
    var taskArray: [Todo] = []
    
    func getAllTasks() -> [Todo] {
        return taskArray
    }
    
    func removeTask(at index: Int) {
        taskArray.remove(at: index)
    }
    
    func update(todo: Todo) {
        guard let index = taskArray.firstIndex(where: { $0.id == todo.id }) else { return }
        taskArray.remove(at: index)
        taskArray.insert(todo, at: index)
    }
    
    func insert(todo: Todo, at index: Int) {
        taskArray.insert(todo, at: index)
    }
        
    func fetchGoods(completion: (([Todo]) -> ())? = nil) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error { return }
 
            guard let data = data else { return }
            
            self.handleResponse(with: data, completion: completion)
        }
        task.resume()
    }
    
    func handleResponse(with data: Data, completion: (([Todo]) -> ())? = nil) {
        do {
            
            let response = try JSONDecoder().decode(Welcome.self, from: data)
            self.taskArray = response.todos
            completion?(self.taskArray)
        } catch {
            
            print("Error decoding data: \(error.localizedDescription)")
        }
    }
}
