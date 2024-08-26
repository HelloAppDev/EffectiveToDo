//
//  ToDoPresenter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

class TodoListPresenter: TodoListPresenterProtocol {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol
    var router: TodoListRouterProtocol
    
    var tasks: [Todo] = []
    
    init(view: TodoListViewProtocol,
         interactor: TodoListInteractorProtocol,
         router: TodoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchTasks()
    }
    
    func convertAsTask(_ todoDBO: [TodoDBO]) -> [Todo] {
        return todoDBO.map { todoDBO in
            Todo(id: todoDBO.id,
                 title: todoDBO.title,
                 subtitle: todoDBO.subtitle,
                 createdAt: todoDBO.createdAt,
                 isCompleted: todoDBO.isCompleted)
        }
    }
    
    func didFetchTasks(_ tasks: [Todo]) {
        self.tasks = tasks
        view?.refreshTodoList()
    }
    
    func routeToAddTask() {
        router.navigateToNewTask()
    }
    
    func navigateToDetail(_ todo: Todo) {
        router.navigateToTaskDetail(with: todo)
    }
}
