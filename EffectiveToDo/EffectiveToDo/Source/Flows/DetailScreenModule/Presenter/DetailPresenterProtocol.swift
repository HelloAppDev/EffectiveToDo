//
//  DetailPresenterProtocol.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var task: Todo? { get }
    func viewDidLoad()
    func saveButtonTapped(title: String?, subtitle: String?, isCompleted: Bool)
}
