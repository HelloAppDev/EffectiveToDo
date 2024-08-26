//
//  TodoListRouter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import UIKit

class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()

        let presenter = TodoListPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateToNewTask() {
        let todoModule = DetailRouter.createModule()
        viewController?.navigationController?.pushViewController(todoModule, animated: true)
    }

    func navigateToTaskDetail(with task: Todo) {
        let todoModule = DetailRouter.createModule(with: task)
        viewController?.navigationController?.pushViewController(todoModule, animated: true)
    }
}
