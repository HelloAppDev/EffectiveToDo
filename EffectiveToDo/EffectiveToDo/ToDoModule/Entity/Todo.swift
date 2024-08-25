//
//  Todo.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

struct Todo: Codable {
    let title: String
    let subtitle: String?
    let createdAt: Date?
    let isCompleted: Bool

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case title = "todo"
        case isCompleted = "completed"
        case createdAt
        case subtitle
    }

    // MARK: - Init

    init(title: String,
         subtitle: String?,
         createdAt: Date?,
         isCompleted: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}

// MARK: - Init decoder

extension Todo {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.createdAt = try? container.decode(Date.self, forKey: .createdAt)
        self.subtitle = try? container.decode(String.self, forKey: .subtitle)
    }
}
