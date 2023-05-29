//
//  CategoryWebsiteView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 29.05.2023.
//

import UIKit

final class CategoryWebsiteView: UIView {
    
    // MARK: - Nested

    struct Model {
        let text: String
        let color: UIColor
    }
    
    private enum Constants {
        static let horizontalInset: CGFloat = 8
        static let horizontalSpacing: CGFloat = 4
        static let verticalInset: CGFloat = 4
        static let maxTextWidth: CGFloat = 120
        static let circleViewSize = CGSize(square: 8)
    }
    
    // MARK: - Internal
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(model: Model) {
        label.text = model.text
        circleView.backgroundColor = model.color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Private
    
    private let circleView = UIView()
    private let label = UILabel()
    
    private func configureView() {
        circleView.layer.cornerRadius = Constants.circleViewSize.width / 2
        
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .secondaryLabel
        
        backgroundColor = .secondarySystemBackground
    }
    
    private func setupLayout() {
        [label, circleView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            circleView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: Constants.circleViewSize.width),
            circleView.heightAnchor.constraint(equalToConstant: Constants.circleViewSize.height),
            
            label.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: Constants.horizontalSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalInset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalInset),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.maxTextWidth)
        ])
    }

}
