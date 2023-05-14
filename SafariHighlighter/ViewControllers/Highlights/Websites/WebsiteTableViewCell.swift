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
        let uniqueId: UUID
        var logo: UIImage?
        let title: String?
        let subtitle: String?
        let count: String?
    }
    
    private enum Constants {
        static let previewSize = CGSize(square: 44)
        static let previewLogoSize = CGSize(square: 32)
        static let horizontalInset: CGFloat = 16
        static let horizontalSpacing: CGFloat = 16
        static let verticalInset: CGFloat = 12
        static let verticalSpacing: CGFloat = 4
    }
    
    // MARK: Internal
    
    var uniqueId: UUID?
    
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
        uniqueId = model.uniqueId
        
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
    private let logoImageBackgroundView = UIView()
    
    private func configureSubviews() {
        titleLabel.font = .preferredFont(forTextStyle: .body)
        
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        
        countLabel.font = .preferredFont(forTextStyle: .caption1)
        
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalSpacing
        stackView.alignment = .leading
        
        logoImageBackgroundView.backgroundColor = .quaternarySystemFill
        logoImageBackgroundView.layer.cornerRadius = 8
        
        logoImageView.tintColor = .white
        
    }
    
    private func configureLayout() {
        logoImageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageBackgroundView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageBackgroundView.addSubview(logoImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(countLabel)

        NSLayoutConstraint.activate([
            logoImageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            logoImageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset),
            logoImageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalInset),
            logoImageBackgroundView.widthAnchor.constraint(equalToConstant: Constants.previewSize.width),
            logoImageBackgroundView.heightAnchor.constraint(equalToConstant: Constants.previewSize.height),
            
            logoImageView.centerYAnchor.constraint(equalTo: logoImageBackgroundView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoImageBackgroundView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.previewLogoSize.height),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.previewLogoSize.width),
            
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: logoImageBackgroundView.trailingAnchor, constant: Constants.horizontalSpacing),
            stackView.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -Constants.horizontalSpacing),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

