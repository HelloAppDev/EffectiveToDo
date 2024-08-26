//
//  TodoListViewController.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 23.08.2024.
//

import UIKit
import SnapKit

final class TodoListViewController: UIViewController, TodoListViewProtocol {
    var presenter: TodoListPresenterProtocol?

    private lazy var tableView = UITableView().forAutolayout().applying {
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: ToDoTableViewCell.reuseId
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupUI()
        addBarButtonItem()
        presenter?.viewDidLoad()
    }
}

// MARK: - Refresh data

extension TodoListViewController {
    func refreshTodoList() {
        tableView.reloadData()
    }
}

// MARK: - Setup UI

extension TodoListViewController {
    private func prepareUI() {
        view.backgroundColor = .white
        self.title = "To-Do list"
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func addBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTask)
        )
    }

    @objc private func addTask() {
        presenter?.routeToAddTask()
    }
}

// MARK: - UITableViewDataSource

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseId) as? ToDoTableViewCell else {
            return UITableViewCell()
        }

        if let task = presenter?.tasks[indexPath.row] {
            cell.updateCell(with: task)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ToDoTableViewCell.sizeThatFits(size: tableView.frame.size).height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = presenter?.tasks[indexPath.row] {
            presenter?.navigateToDetail(task)
        }
    }
}
