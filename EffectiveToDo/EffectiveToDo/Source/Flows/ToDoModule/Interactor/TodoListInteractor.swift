//
//  TodoListInteractor.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation
import CoreData

private enum Constants {
    static let url = "https://dummyjson.com/todos"
}

protocol TodoModuleInput: AnyObject {
    func receiveDataFromDetailModule(task: Todo)
}

class TodoListInteractor: TodoListInteractorProtocol {
    weak var presenter: TodoListPresenterProtocol?
    let coreDataManager = CoreDataManager.shared
    let globalqueue = DispatchQueue.global(qos: .background)

    func fetchTasks() {
        if LaunchManager.shared.isFirstLaunch {
            fetchTasksFromAPI()
        } else {
            loadTasksFromCoreData()
        }
    }

    func loadTasksFromCoreData() {
        globalqueue.async { [weak self] in
            guard let self else { return }
            let context = self.coreDataManager.context
            let fetchRequest: NSFetchRequest<TodoDBO> = TodoDBO.fetchRequest()
            
            do {
                let tasksDBO = try context.fetch(fetchRequest)
                let tasks = self.presenter?.convertAsTask(tasksDBO) ?? []
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks)
                }
            } catch {
                // TODO: handle error
                print(error)
            }
        }
    }

    func saveTaskToCoreData(task: Todo) {
        globalqueue.async { [weak self] in
            guard let self else { return }
            let context = self.coreDataManager.context
            let todo = TodoDBO(context: context)
            todo.update(by: task)

            do {
                try context.save()
            } catch {
                // TODO: handle error
                print(error)
            }
        }
    }

    func saveOrUpdateTask(_ task: Todo, completion: @escaping () -> Void) {
        globalqueue.async { [weak self] in
            guard let self else { return }
            let context = self.coreDataManager.context
            let fetchRequest: NSFetchRequest<TodoDBO> = TodoDBO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: task.id))

            do {
                let results = try context.fetch(fetchRequest)

                if let todoToUpdate = results.first {
                    todoToUpdate.update(by: task)
                } else {
                    let newTodo = TodoDBO(context: context)
                    newTodo.update(by: task)
                }

                try context.save()

                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                // TODO: handle error
                print(error)
            }
        }
    }

    func deleteTask(_ task: Todo) {
        globalqueue.async { [weak self] in
            guard let self else { return }
            let context = self.coreDataManager.context

            let fetchRequest: NSFetchRequest<TodoDBO> = TodoDBO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: task.id))

            do {
                if let todoToDelete = try context.fetch(fetchRequest).first {
                    context.delete(todoToDelete)
                    try context.save()
                }
            } catch {
                // TODO: handle error
                print(error)
            }
        }
    }

    private func saveTasksFromAPI(tasks: [Todo]) {
        let context = coreDataManager.context

        for todoItem in tasks {
            let todoDBO = TodoDBO(context: context)
            todoDBO.id = Int64(todoItem.id)
            todoDBO.title = todoItem.title
            todoDBO.subtitle = todoItem.subtitle
            todoDBO.createdAt = todoItem.createdAt
            todoDBO.isCompleted = todoItem.isCompleted
        }

        do {
            try context.save()
        } catch {
            // TODO: handle error
            print(error)
        }
    }
}

// MARK: - Work with API

extension TodoListInteractor {
    private func fetchTasksFromAPI() {
        globalqueue.async { [weak self] in
            guard let self else { return }
            guard let url = URL(string: Constants.url) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    // TODO: handle error
                    print(error)
                    return
                }

                guard let data = data else { return }
                do {
                    let jsonDecoder = JSONDecoder()
                    let todoResponse = try jsonDecoder.decode(TodoResponse.self, from: data)
                    self.saveTasksFromAPI(tasks: todoResponse.todos)
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTasks(todoResponse.todos)
                    }
                } catch let jsonError {
                    // TODO: handle error
                    print(jsonError)
                }
            }
            task.resume()
        }
    }
}

// MARK: - First module input

extension TodoListInteractor: TodoModuleInput {
    func receiveDataFromDetailModule(task: Todo) {
        saveOrUpdateTask(task) { [weak self] in
            self?.fetchTasks()
        }
    }
}
