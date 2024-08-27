//
//  DetailPresenter.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?

    var task: Todo?

    func saveTodo(with task: Todo) {
        router?.navigateBack(with: task)
    }
}
