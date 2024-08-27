//
//  DetailRouterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

protocol DetailRouterProtocol: AnyObject {
    var firstModuleInput: FirstModuleInput? { get set }

    func navigateBack(with task: Todo)
}
