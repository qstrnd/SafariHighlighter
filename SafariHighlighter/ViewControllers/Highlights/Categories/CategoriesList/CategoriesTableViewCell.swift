//
//  CategoriesTableViewCell.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit

final class CategoriesTableViewCell: UITableViewCell {
    
    // MARK: - Nested
    
    struct Model {
        let color: UIColor
        let title: String
        let subtitle: String?
    }
    
    private enum Constants {
        static let circleViewSize = CGSize(square: 24)
        static let horizontalInsets: CGFloat = 16
    }
    
    // MARK: Internal
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
    func set(model: Model) {
        circleView.backgroundColor = model.color
        titleLabel.text = model.title
        
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.subtitle == nil
    }
    
    // MARK: - Private
    
    private let circleView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private func configureSubviews() {
        titleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
    }
    
    private func configureLayout() {
        // Configure circle view
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circleView)
        
        // Configure title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Configure subtitle label
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(subtitleLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInsets),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: Constants.circleViewSize.width),
            circleView.heightAnchor.constraint(equalToConstant: Constants.circleViewSize.height),
            
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInsets),
            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: Constants.horizontalInsets),
            titleLabel.trailingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor, constant: -Constants.horizontalInsets),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
}
