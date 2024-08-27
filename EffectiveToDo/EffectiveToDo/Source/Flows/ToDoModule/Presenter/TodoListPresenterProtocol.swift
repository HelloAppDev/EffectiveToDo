//
//  TodoListPresenterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

protocol TodoListPresenterProtocol: AnyObject {
    var view: TodoListViewProtocol? { get set }
    var interactor: TodoListInteractorProtocol { get set }
    var router: TodoListRouterProtocol { get set }

    var tasks: [Todo] { get set }

    func viewDidLoad()
    func convertAsTask(_ todoDBO: [TodoDBO]) -> [Todo]
    func didFetchTasks(_ tasks: [Todo])
    func deleteTask(by id: Int)
    func routeToAddTask()
    func navigateToDetail(_ todo: Todo)
}
