//
//  TodoListRouterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import UIKit

protocol TodoListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToNewTask(input: TodoModuleInput)
    func navigateToTaskDetail(with task: Todo, input: TodoModuleInput)
}
