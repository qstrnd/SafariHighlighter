//
//  Highlight.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import Foundation

public struct Highlight {
    public let uniqueId: UUID
    public let creationDate: Date
    public let text: String
    public let location: String

    public init(
        uniqueId: UUID = .init(),
        creationDate: Date = .init(),
        text: String,
        location: String
    ) {
        self.uniqueId = uniqueId
        self.creationDate = creationDate
        self.text = text
        self.location = location
    }
}
