//
//  CategoriesCellViewModelMapper.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit
import Persistence

final class CategoriesCellViewModelMapper: NSObject {
    
    typealias Category = Persistence.Category
    
    // MARK: - Internal
    
    func cellModel(from category: Category) -> CategoriesTableViewCell.Model {
        .init(
            color: color(for: category.name),
            title: category.name,
            subtitle: "4"
        )
    }
    
    // MARK: - Private
    
    private func color(for categoryName: String) -> UIColor {
        switch categoryName {
        case "red":
            return .systemRed
        case "orange":
            return .systemOrange
        case "yellow":
            return .systemYellow
        case "green":
            return .systemGreen
        case "blue":
            return .systemBlue
        case "purple":
            return .systemPurple
        default:
            return .gray
        }
    }
}