//
//  CategoriesCellViewModelMapper.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit
import Persistence

final class CategoriesCellViewModelMapper {
    
    typealias Category = Persistence.Category
    
    // MARK: - Internal
    
    init(appStorage: AppStorage) {
        self.appStorage = appStorage
    }
    
    func cellModel(from category: Category) -> CategoriesTableViewCell.Model {
        .init(
            color: color(for: category),
            title: category.name,
            subtitle: numberOfHighlightsString(for: category.numberOfHighlights)
        )
    }
    
    // MARK: - Private
    
    private let appStorage: AppStorage
    
    private func color(for category: Category) -> UIColor {
        guard let categoryColor = UIColor(hex: category.hexColor) else { return .gray }
        
        return categoryColor
    }
    
    private func numberOfHighlightsString(for numberOfHighlights: Int?) -> String? {
        guard let numberOfHighlights, numberOfHighlights > 0 else { return nil }
        
        return "\(numberOfHighlights)"
    }
}
