//
//  FullHighlight.swift
//  
//
//  Created by Andrey Yakovlev on 29.05.2023.
//

import Foundation

public struct FullHighlight {
    public let highlight: Highlight
    public let website: Website
    public let category: Category

    public init(
        highlight: Highlight,
        website: Website,
        category: Category
    ) {
        self.highlight = highlight
        self.website = website
        self.category = category
    }

    init(from persistedHighlight: PersistedHighlight) {
        self.highlight = Highlight(from: persistedHighlight)
//        self.website = Website(from: persistedHighlight.website!)
//        self.category = Category(from: persistedHighlight.category!)
        
        // TODO: REMOVE IN PROD
        
        if let persistedWebsite = persistedHighlight.website {
            self.website = Website(from: persistedWebsite)
        } else {
            self.website = Website(name: "blabla", url: URL(string: "https://www.mysuperwebsite.com/")!)
        }
        
        if let persistedCategory = persistedHighlight.category {
            self.category = Category(from: persistedCategory)
        } else {
            self.category = Category(name: "Red", hexColor: "#FF3B30")
        }
    }
}
