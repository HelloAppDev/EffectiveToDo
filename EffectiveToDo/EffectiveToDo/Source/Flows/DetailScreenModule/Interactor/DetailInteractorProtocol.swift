//
//  DetailInteractorProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

protocol DetailInteractorProtocol: AnyObject {
    func getTask(by title: String, subtitle: String?, isCompleted: Bool) -> Todo
}
