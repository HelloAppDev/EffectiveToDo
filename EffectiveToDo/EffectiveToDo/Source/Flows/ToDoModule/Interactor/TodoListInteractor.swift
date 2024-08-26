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
        if LaunchManager.shared.isFirstLaunch {
            fetchTasksFromAPI()
        } else {
            fetchTasksFromCoreData()
        }
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

    func saveTaskToCoreData(task: Todo) {
        let context = coreDataManager.context

        let todo = TodoDBO(context: context)
        todo.id = task.id ?? ""
        todo.title = task.title
        todo.subtitle = task.subtitle ?? ""
        todo.createdAt = task.createdAt ?? Date()
        todo.isCompleted = task.isCompleted

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func removeTaskFromDB(task: Todo) {
        let context = coreDataManager.context
        
        let fetchRequest: NSFetchRequest<TodoDBO> = TodoDBO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id ?? "" as CVarArg)
        
        do {
            if let todoToDelete = try context.fetch(fetchRequest).first {
                context.delete(todoToDelete)
                try context.save()
            }
        } catch {
            print(error)
        }
    }
}

extension TodoListInteractor: DataReceiverInteractorInput {
    func receiveData(_ todo: Todo) {
        saveTaskToCoreData(task: todo)
    }
}
