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
        let color: UIColor
        let date: String
        let website: String?
    }
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let horizontalSpacing: CGFloat = 8
        static let topInset: CGFloat = 12
        static let bottomInset: CGFloat = 16
        static let verticalSpacing: CGFloat = 12
        static let circleViewSize = CGSize(square: 8)
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
        circleView.backgroundColor = model.color
        
        dateLabel.text = model.date
        
        websiteLabel.isHidden = model.website == nil
        websiteLabel.text = model.website
    }
    
    // MARK: - Private
    
    private let highlightLabel = UILabel()
    private let circleView = UIView()
    private let websiteLabel = UILabel()
    private let dateLabel = UILabel()
    
    private func configureSubviews() {
        highlightLabel.numberOfLines = 0
        highlightLabel.font = .preferredFont(forTextStyle: .body)
        
        websiteLabel.font = .preferredFont(forTextStyle: .caption1)
        websiteLabel.textColor = .secondaryLabel
        websiteLabel.numberOfLines = 1
        
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel
        dateLabel.numberOfLines = 1
        
        circleView.layer.cornerRadius = Constants.circleViewSize.width / 2
    }
    
    private func configureLayout() {
        [highlightLabel, circleView, websiteLabel, dateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            highlightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            highlightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            highlightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topInset),
            
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            circleView.topAnchor.constraint(equalTo: highlightLabel.bottomAnchor, constant: Constants.verticalSpacing),
            circleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomInset),
            circleView.widthAnchor.constraint(equalToConstant: Constants.circleViewSize.width),
            circleView.heightAnchor.constraint(equalToConstant: Constants.circleViewSize.height),
            
            websiteLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: Constants.horizontalSpacing),
            websiteLabel.trailingAnchor.constraint(greaterThanOrEqualTo: dateLabel.leadingAnchor, constant: -Constants.horizontalInset),
            websiteLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            dateLabel.centerYAnchor.constraint(equalTo: websiteLabel.centerYAnchor),
        ])
    }

}
