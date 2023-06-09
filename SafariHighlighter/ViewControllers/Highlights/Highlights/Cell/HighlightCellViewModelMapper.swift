//
//  HighlightCellViewModelMapper.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 29.05.2023.
//

import UIKit
import Persistence

final class HighlightCellViewModelMapper {
    
    typealias Category = Persistence.Category
    
    private lazy var dateFormatter = {
        let relativeDateFormatter = DateFormatter()
        
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale.current
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        return relativeDateFormatter
    }()
    
    // MARK: - Internal
    
    func cellModel(from highlight: FullHighlight) -> HighlightTableViewCell.Model {
        let highlightInfo = CategoryWebsiteView.Model(
            text: websiteInfo(for: highlight.website) ?? "",
            color: color(for: highlight.category)
        )
        
        return HighlightTableViewCell.Model(
            text: highlight.highlight.text,
            date: dateFormatter.string(from: highlight.highlight.creationDate),
            highlightInfo: highlightInfo
        )
    }
    
    // MARK: - Private
    
    private func color(for category: Category) -> UIColor {
        guard let categoryColor = UIColor(hex: category.hexColor) else { return .gray }
        
        return categoryColor
    }
    
    private func websiteInfo(for website: Website) -> String? {
        guard let host = website.url.host else { return nil }
        let name = host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
        return name
    }
}
