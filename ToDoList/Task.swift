//
//  Task.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

struct Task: Hashable, Identifiable {
    let id: UUID = UUID()
    var title: String
    var isTaskDone: Bool
    var dateOfCreating: Date
}
