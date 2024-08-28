//
//  DetailRouter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import UIKit

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?
    weak var firstModuleInput: TodoModuleInput?

    func navigateBack(with task: Todo) {
        firstModuleInput?.receiveDataFromDetailModule(task: task)
        viewController?.navigationController?.popViewController(animated: true)
    }

    static func createModule(with task: Todo? = nil, input: TodoModuleInput?) -> UIViewController {
        let presenter = DetailPresenter()
        presenter.task = task
        let view = DetailViewController(presenter: presenter)
        let interactor = DetailInteractor()
        let router = DetailRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        router.firstModuleInput = input

        return view
    }
}
