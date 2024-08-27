//
//  DetailViewProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    var task: Todo? { get }
    func displayTask(_ task: Todo?)
    func displayError(_ message: String)
}
