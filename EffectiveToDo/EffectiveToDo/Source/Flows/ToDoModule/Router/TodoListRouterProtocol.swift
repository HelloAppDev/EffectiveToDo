//
//  TodoListRouterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

protocol TodoListRouterProtocol: AnyObject {
    func navigateToNewTask(input: TodoModuleInput)
    func navigateToTaskDetail(with task: Todo, input: TodoModuleInput)
}
