//
//  DetailRouterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    var firstModuleInput: TodoModuleInput? { get set }
    static func createModule(with task: Todo?, input: TodoModuleInput?) -> UIViewController
    func navigateBack(with task: Todo)
}
