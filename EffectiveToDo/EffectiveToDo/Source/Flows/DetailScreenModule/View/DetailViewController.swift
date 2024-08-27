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
    static let error = "Ошибка"
    static let saveButtonTitle = "Save"
    static let completeImage = UIImage(named: "сompleted")
    static let notCompleteImage = UIImage(named: "notCompleted")
    static let titleFont: UIFont = .boldSystemFont(ofSize: 16)
    static let textFieldFont: UIFont = .systemFont(ofSize: 14)
}

class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol

    // MARK: Private properties
    
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

    var task: Todo?

    // MARK: Lifecycle
    
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
        presenter.viewDidLoad()
        hideKeyBoardOnTap()
        registerNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
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

// MARK: - Work with Notification center & handle keyboard displaying

extension DetailViewController {
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        adjustSaveButtonPosition(showing: true, notification: notification)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        adjustSaveButtonPosition(showing: false, notification: notification)
    }

    private func adjustSaveButtonPosition(showing: Bool, notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let adjustmentHeight = showing ? -(keyboardFrame.height + 10) : -80

        UIView.animate(withDuration: animationDuration) {
            self.saveButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(adjustmentHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - User interactive methods

extension DetailViewController: DetailViewProtocol {
    @objc private func completedButtonTapped() {
        isCompleted.toggle()
    }

    @objc private func saveButtonTapped() {
        presenter.saveButtonTapped(
            title: titleTextField.text,
            subtitle: subtitleTextField.text,
            isCompleted: isCompleted
        )
    }

    func displayError(_ message: String) {
        let alertController = UIAlertController(
            title: Constants.error,
            message: message,
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

// MARK: - Display Task

extension DetailViewController {
    func displayTask(_ task: Todo?) {
        titleTextField.text = task?.title
        subtitleTextField.text = task?.subtitle
        isCompleted = task?.isCompleted ?? false
        completedButton.isSelected = isCompleted
        saveButton.isEnabled = self.task != task
    }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let currentText = textField.text as NSString? else { return true }

           let updatedText = currentText.replacingCharacters(in: range, with: string)

        if task == nil {
            task = Todo(
                title: textField == titleTextField ? updatedText : "",
                subtitle: textField == subtitleTextField ? updatedText : nil,
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
