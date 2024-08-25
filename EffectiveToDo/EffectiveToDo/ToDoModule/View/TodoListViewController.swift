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
    
    private var mockData = [
    "First Habit",
    "Second Habit",
    "Third Habit",
    "Fourth Habit",
    "Fifth Habit",
    "Sixth Habit"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        self.title = "To-Do list"
        prepare()
        presenter?.viewDidLoad()
    }

    private func prepare() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func refreshTodoList() {
        tableView.reloadData()
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
}
