//
//  TodoListPresenter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

final class TodoListPresenter: TodoListPresenterProtocol {
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
            Todo(id: Int(todoDBO.id),
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
        router.navigateToNewTask(input: interactor as! TodoModuleInput)
    }

    func navigateToDetail(_ todo: Todo) {
        router.navigateToTaskDetail(with: todo, input: interactor as! TodoModuleInput)
    }

    func deleteTask(by id: Int) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == id }),
        let task = tasks.first(where: { $0.id == id }) else { return }
        tasks.remove(at: taskIndex)
        interactor.deleteTask(task)
    }
}
