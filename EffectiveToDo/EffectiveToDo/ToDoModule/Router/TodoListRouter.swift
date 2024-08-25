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
    
    func navigateToTaskDetail(with task: Todo) {
        // Реализация навигации на другой экран
        // Например, создать TaskDetailViewController и настроить его
//        let taskDetailViewController = TaskDetailRouter.createModule(with: task)
//        viewController?.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
}
