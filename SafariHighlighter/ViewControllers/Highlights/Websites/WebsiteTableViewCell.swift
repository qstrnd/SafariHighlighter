//
//  WebsiteTableViewCell.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit

final class WebsiteTableViewCell: UITableViewCell {
    
    // MARK: - Nested
    
    struct Model {
        let logo: UIImage?
        let title: String?
        let subtitle: String?
        let count: String?
    }
    
    private enum Constants {
        static let previewSize = CGSize(square: 44)
        static let horizontalInset: CGFloat = 16
        static let horizontalSpacing: CGFloat = 16
        static let verticalInset: CGFloat = 12
        static let verticalSpacing: CGFloat = 4
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
    }
    
    func set(model: Model) {
        titleLabel.text = model.title
        titleLabel.isHidden = model.title == nil
        
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.subtitle == nil
        
        logoImageView.image = model.logo ?? UIImage(systemName: "globe")
        
        countLabel.text = model.count
        countLabel.isHidden = model.count == nil
    }
    
    // MARK: - Private
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let countLabel = UILabel()
    private let stackView = UIStackView()
    private let logoImageView = UIImageView()
    
    private func configureSubviews() {
        titleLabel.font = .preferredFont(forTextStyle: .body)
        
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        
        countLabel.font = .preferredFont(forTextStyle: .caption1)
        
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalSpacing
        stackView.alignment = .leading
        
        logoImageView.backgroundColor = .quaternarySystemFill
        logoImageView.layer.cornerRadius = 8
        logoImageView.tintColor = .white
        
    }
    
    private func configureLayout() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(countLabel)

        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset),
            logoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalInset),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.previewSize.width),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.previewSize.height),
            
            // Count label constraints
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Title label constraints
            stackView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: Constants.horizontalSpacing),
            stackView.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -Constants.horizontalSpacing),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

