//
//  Todo.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 01.12.2024.


import UIKit

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
struct Welcome: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}
