//
//  Website.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import Foundation

public struct Website {
    public let uniqueId: UUID
    public let creationDate: Date
    public let name: String
    public let url: URL
    
    public let numberOfHighlights: Int?

    public init(
        uniqueId: UUID = .init(),
        creationDate: Date = .init(),
        name: String,
        url: URL,
        numberOfHighlights: Int? = nil
    ) {
        self.uniqueId = uniqueId
        self.creationDate = creationDate
        self.name = name
        self.url = url
        self.numberOfHighlights = numberOfHighlights
    }

    init(from persistedWebsite: PersistedWebsite) {
        self.uniqueId = persistedWebsite.uniqueId!
        self.creationDate = persistedWebsite.creationDate!
        self.name = persistedWebsite.name!
        self.url = URL(string: persistedWebsite.url!)!
        self.numberOfHighlights = persistedWebsite.highlights?.count ?? 0
    }
}
