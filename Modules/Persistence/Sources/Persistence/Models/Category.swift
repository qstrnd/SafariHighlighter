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
    public let name: String

    public init(
        uniqueId: UUID = .init(),
        name: String
    ) {
        self.uniqueId = uniqueId
        self.name = name
    }
}
