//
//  DetailInteractor.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

final class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailPresenterProtocol?

    func getTask(by title: String, subtitle: String?, isCompleted: Bool) -> Todo {
        let todoSubtitle = subtitle?.isEmpty == true ? nil : subtitle

        let todo = presenter?.task?.changeParams(
            title: title,
            subtitle: todoSubtitle,
            completed: isCompleted
        ) ?? Todo(
            id: abs(UUID().uuidString.hashValue),
            title: title,
            subtitle: todoSubtitle,
            createdAt: Date(),
            isCompleted: isCompleted
        )

        return todo
    }
}
