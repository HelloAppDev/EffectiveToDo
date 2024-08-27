//
//  DetailViewController.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 26.08.2024.
//

import UIKit
import SnapKit

private enum Constants {
    static let titleText = "Title"
    static let subtitleText = "Subtitle"
    static let completeText = "Complete task"
    static let titleTFPlaceholder = "Enter title"
    static let subtitleTFPlaceholder = "Enter subtitle"
    static let saveButtonTitle = "Save"
    static let error = "Ошибка"
    static let errorText = "Задайте название действию."
    static let completeImage = UIImage(named: "сompleted")
    static let notCompleteImage = UIImage(named: "notCompleted")
    static let titleFont: UIFont = .boldSystemFont(ofSize: 16)
    static let textFieldFont: UIFont = .systemFont(ofSize: 14)
}

class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol

    private lazy var titleLabel = UILabel().forAutolayout().applying {
        $0.text = Constants.titleText
        $0.font = Constants.titleFont
    }

    private lazy var subtitleLabel = UILabel().forAutolayout().applying {
        $0.text = Constants.subtitleText
        $0.font = Constants.titleFont
    }

    private lazy var completedLabel = UILabel().forAutolayout().applying {
        $0.text = Constants.completeText
        $0.font = Constants.titleFont
    }

    private lazy var titleTextField = UITextField().forAutolayout().applying {
        $0.borderStyle = .roundedRect
        $0.placeholder = Constants.titleTFPlaceholder
        $0.font = Constants.textFieldFont
    }

    private lazy var subtitleTextField = UITextField().forAutolayout().applying {
        $0.borderStyle = .roundedRect
        $0.placeholder = Constants.subtitleTFPlaceholder
        $0.font = Constants.textFieldFont
    }

    private lazy var completedButton = UIButton().forAutolayout().applying {
        $0.addTarget(self, action: #selector(completedButtonTapped), for: .touchUpInside)
    }

    private lazy var saveButton = UIButton().forAutolayout().applying {
        $0.setTitle(Constants.saveButtonTitle, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 12
        $0.layer.backgroundColor = UIColor.blue.cgColor
    }

    private var isCompleted = false {
        didSet {
            toggleComplete()
        }
    }

    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        updateContent()
    }
}

// MARK: - Setup views

extension DetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(subtitleLabel)
        view.addSubview(subtitleTextField)
        view.addSubview(completedLabel)
        view.addSubview(completedButton)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel)
        }

        subtitleTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleTextField)
        }

        completedLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleTextField.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel)
        }

        completedButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleTextField.snp.bottom).offset(20)
            make.size.equalTo(40)
            make.trailing.equalToSuperview().offset(-10)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-80)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
    }

    private func toggleComplete() {
        completedButton.isSelected = isCompleted
        completedButton.setImage(isCompleted
                                 ? Constants.completeImage
                                 : Constants.notCompleteImage,
                                 for: .normal)
    }
}

// MARK: - User interactive methods

extension DetailViewController {
    @objc private func completedButtonTapped() {
        isCompleted.toggle()
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text,
                  !title.isEmpty else {
            showAlertForEmptyTitle()
            return
        }

        let subtitle = subtitleTextField.text

        if let task = presenter.task {
            let todo = task.changeParams(title: title,
                                         subtitle: subtitle,
                                         completed: isCompleted)

            presenter.saveTodo(with: todo)
        } else {
            let newTodo = Todo(
                id: abs(UUID().uuidString.hashValue),
                title: title,
                subtitle: subtitle,
                createdAt: Date(),
                isCompleted: isCompleted
            )

            presenter.saveTodo(with: newTodo)
        }
    }

    private func showAlertForEmptyTitle() {
        let alertController = UIAlertController(
            title: Constants.error,
            message: Constants.errorText,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Update content

extension DetailViewController {
    private func updateContent() {
        titleTextField.text = presenter.task?.title
        subtitleTextField.text = presenter.task?.subtitle
        isCompleted = presenter.task?.isCompleted ?? false
        completedButton.isSelected = isCompleted
    }
}

extension DetailViewController: DetailViewProtocol {
}

