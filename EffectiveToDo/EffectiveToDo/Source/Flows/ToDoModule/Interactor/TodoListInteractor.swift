//
//  TodoListInteractor.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation
import CoreData

protocol FirstModuleInput: AnyObject {
    func receiveDataFromSecondModule(task: Todo)
}

class TodoListInteractor: TodoListInteractorProtocol {
    var presenter: TodoListPresenterProtocol?
    let coreDataManager = CoreDataManager.shared

    func fetchTasks() {
        if LaunchManager.shared.isFirstLaunch {
            fetchTasksFromAPI()
        } else {
            loadTasksFromCoreData()
        }
    }

    func loadTasksFromCoreData() {
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
    
    func saveOrUpdateTask(_ task: Todo) {
        let context = coreDataManager.context

        let fetchRequest: NSFetchRequest<TodoDBO> = TodoDBO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id ?? "" as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)

            if let todoToUpdate = results.first {
                todoToUpdate.update(by: task)
            } else {
                let newTodo = TodoDBO(context: context)
                newTodo.id = task.id ?? ""
                newTodo.title = task.title
                newTodo.subtitle = task.subtitle ?? ""
                newTodo.createdAt = task.createdAt ?? Date()
                newTodo.isCompleted = task.isCompleted
            }

            try context.save()
        } catch {
            print(error)
        }
    }

    func deleteTask(_ task: Todo) {
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

// MARK: - Work with API

extension TodoListInteractor {
    private func fetchTasksFromAPI() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print(error)
                    return
                }

                guard let data = data,
                      let self else { return }
                do {
                    let jsonDecoder = JSONDecoder()
                    let todoResponse = try jsonDecoder.decode(TodoResponse.self, from: data)
                    self.saveTasksFromAPI(tasks: todoResponse.todos)
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTasks(todoResponse.todos)
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            }
            task.resume()
        }
    }

    private func saveTasksFromAPI(tasks: [Todo]) {
        let context = coreDataManager.context

        for todoItem in tasks {
            let todoDBO = TodoDBO(context: context)
            todoDBO.id = todoItem.id
            todoDBO.title = todoItem.title
            todoDBO.subtitle = todoItem.subtitle
            todoDBO.createdAt = todoItem.createdAt
            todoDBO.isCompleted = todoItem.isCompleted
        }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - First module input

extension TodoListInteractor: FirstModuleInput {
    func receiveDataFromSecondModule(task: Todo) {
        saveOrUpdateTask(task)
        loadTasksFromCoreData()
    }
}
