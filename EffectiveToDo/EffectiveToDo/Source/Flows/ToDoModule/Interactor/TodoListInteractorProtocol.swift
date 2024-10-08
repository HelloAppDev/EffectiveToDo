//
//  TodoListInteractorProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

protocol TodoListInteractorProtocol: AnyObject {
    var presenter: TodoListPresenterProtocol? { get set }

    func fetchTasks()
    func loadTasksFromCoreData()
    func saveOrUpdateTask(_ task: Todo, completion: @escaping () -> Void)
    func deleteTask(_ task: Todo)
}
