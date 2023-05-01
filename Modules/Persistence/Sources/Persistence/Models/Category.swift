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

    public init(
        uniqueId: UUID = .init(),
        creationDate: Date = .init(),
        name: String
    ) {
        self.uniqueId = uniqueId
        self.creationDate = creationDate
        self.name = name
    }

    init(from persistedCategory: PersistedCategory) {
        self.uniqueId = persistedCategory.uniqueId!
        self.creationDate = persistedCategory.creationDate!
        self.name = persistedCategory.name!
    }
}
