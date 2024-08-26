//
//  Todo.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

struct Todo: Codable {
    let id: String?
    let title: String
    let subtitle: String?
    let createdAt: Date?
    let isCompleted: Bool

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
        case createdAt
        case subtitle
    }
    
    // MARK: - Init
    
    init(id: String?,
         title: String,
         subtitle: String?,
         createdAt: Date?,
         isCompleted: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}

// MARK: - Change existed task

extension Todo {
    func changeParams(title: String,
                      subtitle: String?,
                      completed: Bool) -> Todo {
        return Todo(id: id,
                    title: title,
                    subtitle: subtitle,
                    createdAt: createdAt,
                    isCompleted: completed)
    }
}

// MARK: - Init decoder

extension Todo {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.createdAt = try? container.decode(Date.self, forKey: .createdAt)
        self.subtitle = try? container.decode(String.self, forKey: .subtitle)
    }
}
