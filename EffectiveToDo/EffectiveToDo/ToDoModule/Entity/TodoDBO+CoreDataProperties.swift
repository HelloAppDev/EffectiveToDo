//
//  TodoDBO+CoreDataProperties.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation
import CoreData

extension TodoDBO {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<TodoDBO> {
        return NSFetchRequest<TodoDBO>(entityName: "TodoDBO")
    }

    @NSManaged public var title: String
    @NSManaged public var subtitle: String
    @NSManaged public var createdAt: Date
    @NSManaged public var isCompleted: Bool
}

extension TodoDBO {
    func asTask() -> Todo {
        return Todo(title: title,
                    subtitle: subtitle,
                    createdAt: createdAt,
                    isCompleted: isCompleted)
    }
}