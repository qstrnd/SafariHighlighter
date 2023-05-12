//
//  AppStorage.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import Foundation
import Common

final class AppStorage {
    
    @Storage(key: "selectedTab", defaultValue: 0)
    var selectedTab: Int
    
    @Storage(key: "groupedHighlightsSelectedSegment", defaultValue: 0)
    var groupedHighlightsSelectedSegment: Int
    
    @Storage(key: "isTutorialShown", defaultValue: false)
    var isTutorialShown: Bool
}
