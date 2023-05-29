//
//  HighlightTableViewCell.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 29.05.2023.
//

import UIKit

final class HighlightTableViewCell: UITableViewCell {
    
    // MARK: - Nested
    
    struct Model {
        let text: String
        let date: String
        let highlightInfo: CategoryWebsiteView.Model
    }
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let horizontalSpacing: CGFloat = 8
        static let topInset: CGFloat = 12
        static let bottomInset: CGFloat = 16
        static let verticalSpacing: CGFloat = 12
    }
    
    // MARK: - Internal
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(model: Model) {
        highlightLabel.text = model.text
        dateLabel.text = model.date
        highlightInfoView.set(model: model.highlightInfo)
    }
    
    // MARK: - Private
    
    private let highlightLabel = UILabel()
    private let highlightInfoView = CategoryWebsiteView()
    private let dateLabel = UILabel()
    
    private func configureSubviews() {
        highlightLabel.numberOfLines = 0
        highlightLabel.font = .preferredFont(forTextStyle: .body)
        
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel
        dateLabel.numberOfLines = 1
    }
    
    private func configureLayout() {
        [highlightLabel, highlightInfoView, dateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            highlightInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            highlightInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topInset),
            
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: highlightInfoView.trailingAnchor, constant: Constants.horizontalSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            dateLabel.centerYAnchor.constraint(equalTo: highlightInfoView.centerYAnchor),
            
            highlightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            highlightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            highlightLabel.topAnchor.constraint(equalTo: highlightInfoView.bottomAnchor, constant: Constants.verticalSpacing),
            highlightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomInset),
        ])
    }

}
