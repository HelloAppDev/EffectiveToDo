//
//  DetailInteractor.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import Foundation

class DetailInteractor: DetailInteractorProtocol {
    
    func saveTodo(_ todo: Todo) {
    }
}

protocol DataReceiverInteractorInput: AnyObject {
    func receiveData(_ todo: Todo)
}
