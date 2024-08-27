//
//  ToDoTableViewCell.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import UIKit
import SnapKit

private enum Constants {
    static let reuseId = "ToDoTableViewCell"
    static let titleText = "Title"
    static let subtitleText = "Subtitle"
    static let dateFormat = "dd.MM.yyyy"
    static let completeImage = UIImage(named: "сompleted")
    static let notCompleteImage = UIImage(named: "notCompleted")
    static let titleFont: UIFont = .boldSystemFont(ofSize: 16)
    static let subtitleFont: UIFont = .systemFont(ofSize: 14)
    static let topBottomInset = 10.0
    static let subtitleInset = 6.0
}

final class ToDoTableViewCell: UITableViewCell {
    static let reuseId = Constants.reuseId

    private lazy var titleLabel = UILabel().forAutolayout().applying {
        $0.font = Constants.titleFont
        $0.numberOfLines = 1
    }

    private lazy var subtitleLabel = UILabel().forAutolayout().applying {
        $0.font = Constants.subtitleFont
        $0.numberOfLines = 0
    }

    private lazy var dateLabel = UILabel().forAutolayout().applying {
        $0.font = Constants.subtitleFont
        $0.numberOfLines = 1
    }

    private lazy var completeImage = UIImageView().forAutolayout().applying {
        $0.contentMode = .scaleAspectFit
    }

    private let dateFormatter = DateFormatter()

    // MARK: init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI

extension ToDoTableViewCell {
    private func commonInit() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(completeImage)

        selectionStyle = .none
        dateFormatter.dateFormat = Constants.dateFormat
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Constants.topBottomInset)
            make.trailing.equalTo(completeImage.snp.leading).offset(-10)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleInset)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(completeImage.snp.leading).offset(-10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.subtitleInset)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(completeImage.snp.leading).offset(-10)
        }

        completeImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(30)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - Update cell's content

extension ToDoTableViewCell {
    func updateCell(with task: Todo) {
        titleLabel.text = task.title
        subtitleLabel.text = task.subtitle
        dateLabel.text = dateFormatter.string(from: task.createdAt ?? Date())
        completeImage.image = task.isCompleted
                              ? Constants.completeImage
                              : Constants.notCompleteImage
    }
}

// MARK: - Static func

extension ToDoTableViewCell {
    static func sizeThatFits(size: CGSize, task: Todo) -> CGSize {
        let titleSize = Constants.titleText.boundingRect(
            maxSize: CGSize(
                width: size.width / 2,
                height: size.height
            ),
            font: Constants.titleFont
        ).size

        let subtitleSize = Constants.subtitleText.boundingRect(
            maxSize: CGSize(
                width: size.width / 2,
                height: size.height
            ),
            font: Constants.subtitleFont
        ).size

        let subtitleHeight: CGFloat

        if let subtitle = task.subtitle, !subtitle.isEmpty {
            subtitleHeight = subtitleSize.height * 2
        } else {
            subtitleHeight = subtitleSize.height
        }

        let commonHeight = titleSize.height
        + subtitleHeight
        + (Constants.topBottomInset * 2)
        + (Constants.subtitleInset * 2)

        return CGSize(width: size.width, height: commonHeight)
    }
}
