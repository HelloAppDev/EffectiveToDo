//
//  Todo.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

struct Todo: Codable {
    let id: Int
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
    
    init(id: Int,
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
                    createdAt: createdAt ?? Date(),
                    isCompleted: completed)
    }
}

// MARK: - Compare

extension Todo: Equatable {    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.isCompleted == rhs.isCompleted
    }
}

// MARK: - Init decoder

extension Todo {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.createdAt = try? container.decode(Date.self, forKey: .createdAt)
        self.subtitle = try? container.decode(String.self, forKey: .subtitle)
    }
}
