//
//  DetailPresenter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

private enum Constants {
    static let errorText = "Задайте название действию."
}

class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?

    var task: Todo?

    func viewDidLoad() {
        view?.displayTask(task)
    }

    func saveButtonTapped(title: String?, subtitle: String?, isCompleted: Bool) {
        guard let title = title,
              !title.isEmpty else {
            view?.displayError(Constants.errorText)
            return
        }

        if let interactor {
            let todo = interactor.getTask(
                by: title,
                subtitle: subtitle,
                isCompleted: isCompleted
            )
            router?.navigateBack(with: todo)
        }
    }
}
