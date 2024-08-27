//
//  DetailPresenterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var task: Todo? { get set }

    func saveTodo(with task: Todo)
}
