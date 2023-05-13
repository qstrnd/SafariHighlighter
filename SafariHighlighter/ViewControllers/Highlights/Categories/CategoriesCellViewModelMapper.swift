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
            color: color(for: category.uniqueId),
            title: category.name,
            subtitle: numberOfHighlightsString(for: category.numberOfHighlights)
        )
    }
    
    // MARK: - Private
    
    private let appStorage: AppStorage
    
    private func color(for categoryId: UUID) -> UIColor {
        switch categoryId {
        case appStorage.initialCategoriesIdRed:
            return .systemRed
        case appStorage.initialCategoriesIdOrange:
            return .systemOrange
        case appStorage.initialCategoriesIdYellow:
            return .systemYellow
        case appStorage.initialCategoriesIdGreen:
            return .systemGreen
        case appStorage.initialCategoriesIdBlue:
            return .systemBlue
        case appStorage.initialCategoriesIdPurple:
            return .systemPurple
        default:
            return .gray
        }
    }
    
    private func numberOfHighlightsString(for numberOfHighlights: Int?) -> String? {
        guard let numberOfHighlights, numberOfHighlights > 0 else { return nil }
        
        return "\(numberOfHighlights)"
    }
}
