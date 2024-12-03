//
//  Assignment+CoreDataProperties.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 02.12.2024.
//
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var discriptiontitle: String?
    @NSManaged public var dateOfCreating: Date?
    @NSManaged public var isTaskDone: Bool

}

extension Assignment : Identifiable {

}
