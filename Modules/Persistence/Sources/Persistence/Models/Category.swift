//
//  Category.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import Foundation

/// The category is used to group highlights based on some criterion.
/// The criterion currently in use is color
public struct Category {
    public let uniqueId: UUID
    public let creationDate: Date
    public let name: String
    public let hexColor: String
    
    /// `Nil` if not fetched
    public let numberOfHighlights: Int?

    public init(
        uniqueId: UUID = .init(),
        creationDate: Date = .init(),
        name: String,
        hexColor: String,
        numberOfHighlights: Int? = nil
    ) {
        self.uniqueId = uniqueId
        self.creationDate = creationDate
        self.name = name
        self.numberOfHighlights = numberOfHighlights
        self.hexColor = hexColor
    }

    init(from persistedCategory: PersistedCategory) {
        self.uniqueId = persistedCategory.uniqueId!
        self.creationDate = persistedCategory.creationDate!
        self.name = persistedCategory.name!
        self.numberOfHighlights = persistedCategory.highlights?.count ?? 0
        self.hexColor = persistedCategory.hexColor!
    }
}
