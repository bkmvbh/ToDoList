//
//  Task.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

struct Task: Hashable, Identifiable, Decodable {
    let id: Int
    var title: String
    var discriptiontitle: String
    var isTaskDone: Bool
    var dateOfCreating: Date
}
