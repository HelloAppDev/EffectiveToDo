//
//  TodoListInteractor.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation
import CoreData

class TodoListInteractor: TodoListInteractorProtocol {
    var presenter: TodoListPresenterProtocol?
    let coreDataManager = CoreDataManager.shared

    func fetchTasks() {
       // if LaunchManager.shared.isFirstLaunch {
            fetchTasksFromAPI()
//        } else {
//            fetchTasksFromCoreData()
//        }
    }

    private func fetchTasksFromAPI() {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching tasks from API: \(error)")
                    return
                }
                
                guard let data = data else { return }
                do {
                    let jsonDecoder = JSONDecoder()
                    let todoResponse = try jsonDecoder.decode(TodoResponse.self, from: data)
                    
//                    var todos = [Todo]()
//                    for task in todoResponse.todos {
//                        let todoTask = Todo(title: task.todo,
//                                            subtitle: nil,
//                                            createdAt: <#T##Date#>, isCompleted: <#T##Bool#>)
//                        todos.append(todoTask)
//                    }
//                    self.saveTasksToCoreData(tasks: todos)
                    
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTasks(todoResponse.todos)
                    }
                } catch let jsonError {
                    print("Failed to decode JSON: \(jsonError)")
                }
            }
            task.resume()
        }
    }

    private func fetchTasksFromCoreData() {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<TodoDBO> = TodoDBO.fetchRequest()
        
        do {
            let tasksDBO = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                let tasks = self.presenter?.convertAsTask(tasksDBO)
                self.presenter?.didFetchTasks(tasks ?? [])
            }
        } catch {
            print(error)
        }
    }

    private func saveTasksToCoreData(tasks: [Todo]) {
        let context = coreDataManager.context
        
        for todoItem in tasks {
            let task = TodoDBO(context: context)
            task.title = todoItem.title
            task.subtitle = todoItem.subtitle ?? ""
            task.createdAt = todoItem.createdAt ?? Date()
            task.isCompleted = todoItem.isCompleted
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
