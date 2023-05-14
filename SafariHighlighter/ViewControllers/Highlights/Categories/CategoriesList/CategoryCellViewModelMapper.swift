//
//  CategoryCellViewModelMapper.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit
import Persistence

final class CategoryCellViewModelMapper {
    
    typealias Category = Persistence.Category
    
    // MARK: - Internal
    
    func cellModel(from category: Category) -> CategoryTableViewCell.Model {
        .init(
            color: color(for: category),
            title: category.name,
            subtitle: numberOfHighlightsString(for: category.numberOfHighlights)
        )
    }
    
    // MARK: - Private
    
    private func color(for category: Category) -> UIColor {
        guard let categoryColor = UIColor(hex: category.hexColor) else { return .gray }
        
        return categoryColor
    }
    
    private func numberOfHighlightsString(for numberOfHighlights: Int?) -> String? {
        guard let numberOfHighlights, numberOfHighlights > 0 else { return nil }
        
        return "\(numberOfHighlights)"
    }
}
