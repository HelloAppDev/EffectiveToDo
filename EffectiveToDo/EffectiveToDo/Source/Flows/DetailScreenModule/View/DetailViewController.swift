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
        $0.delegate = self
    }

    private lazy var subtitleTextField = UITextField().forAutolayout().applying {
        $0.borderStyle = .roundedRect
        $0.placeholder = Constants.subtitleTFPlaceholder
        $0.font = Constants.textFieldFont
        $0.delegate = self
    }

    private lazy var completedButton = UIButton().forAutolayout().applying {
        $0.addTarget(self, action: #selector(completedButtonTapped), for: .touchUpInside)
    }

    private lazy var saveButton = UIButton().forAutolayout().applying {
        $0.setTitle(Constants.saveButtonTitle, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 12
        $0.setBackgroundColor(color: .blue, forState: .normal)
        $0.setBackgroundColor(color: .lightGray, forState: .disabled)
    }

    private var isCompleted = false {
        didSet {
            toggleComplete()
        }
    }

    private var task: Todo?

    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        self.task = presenter.task
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
        hideKeyBoardOnTap()
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
        self.task = task?.changeParams(title: task?.title ?? "",
                                       subtitle: task?.subtitle,
                                       completed: isCompleted)
        saveButton.isEnabled = self.task != presenter.task
    }
}

// MARK: - User interactive methods

extension DetailViewController: DetailViewProtocol {
    @objc private func completedButtonTapped() {
        isCompleted.toggle()
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlertForEmptyTitle()
            return
        }

        let subtitle = subtitleTextField.text

        let todo: Todo

        if let task = presenter.task {
            todo = task.changeParams(
                title: title,
                subtitle: subtitle?.isEmpty == true ? nil : subtitle,
                completed: isCompleted
            )
        } else if let task = self.task {
            todo = task.changeParams(
                title: title,
                subtitle: subtitle?.isEmpty == true ? nil : subtitle,
                completed: isCompleted
            )
        } else {
            todo = Todo(
                id: abs(UUID().uuidString.hashValue),
                title: title,
                subtitle: subtitle?.isEmpty == true ? nil : subtitle,
                createdAt: Date(),
                isCompleted: isCompleted
            )
        }

        presenter.saveTodo(with: todo)
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
    
    private func updateSaveButtonState() {
        let hasChanges = !(self.task == presenter.task)
        saveButton.isEnabled = hasChanges
    }
}

// MARK: - Update content

extension DetailViewController {
    private func updateContent() {
        titleTextField.text = presenter.task?.title
        subtitleTextField.text = presenter.task?.subtitle
        isCompleted = presenter.task?.isCompleted ?? false
        completedButton.isSelected = isCompleted
        saveButton.isEnabled = self.task != presenter.task
    }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let currentText = textField.text as NSString? else { return true }

           let updatedText = currentText.replacingCharacters(in: range, with: string)

           if task == nil {
               task = Todo(
                   id: abs(UUID().uuidString.hashValue),
                   title: textField == titleTextField ? updatedText : "",
                   subtitle: textField == subtitleTextField ? updatedText : nil,
                   createdAt: Date(),
                   isCompleted: false
               )
           } else {
               if textField == titleTextField {
                   task = task?.changeParams(
                       title: updatedText,
                       subtitle: task?.subtitle,
                       completed: task?.isCompleted ?? false
                   )
               } else if textField == subtitleTextField {
                   task = task?.changeParams(
                       title: task?.title ?? "",
                       subtitle: updatedText.isEmpty ? nil : updatedText,
                       completed: task?.isCompleted ?? false
                   )
               }
           }

           updateSaveButtonState()

           return true
       }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}
