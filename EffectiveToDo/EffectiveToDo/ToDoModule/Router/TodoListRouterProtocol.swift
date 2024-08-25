//
//  TodoListRouterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

protocol TodoListRouterProtocol: AnyObject {
    func navigateToTaskDetail(with task: Todo)
}
