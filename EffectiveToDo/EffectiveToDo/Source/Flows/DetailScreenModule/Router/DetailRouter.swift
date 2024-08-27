//
//  DetailRouter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import UIKit

class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?
    weak var firstModuleInput: FirstModuleInput?
    
    func navigateBack(with task: Todo) {
        firstModuleInput?.receiveDataFromSecondModule(task: task)
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    static func createModule(with task: Todo? = nil, input: FirstModuleInput?) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter()
        let interactor = DetailInteractor()
        let router = DetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.task = task
        router.viewController = view
        router.firstModuleInput = input

        return view
    }
}
