//
//  AppStorage.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import Foundation
import Common

private let appStorageGroupSuitname = "group.com.qstrnd.SafariHighlighter"

final class AppStorage {
    
    @Storage(suiteName: appStorageGroupSuitname, key: "selectedTab", defaultValue: 0)
    var selectedTab: Int
    
    @Storage(suiteName: appStorageGroupSuitname, key: "groupedHighlightsSelectedSegment", defaultValue: 0)
    var groupedHighlightsSelectedSegment: Int
    
    @Storage(suiteName: appStorageGroupSuitname, key: "isTutorialShown", defaultValue: false)
    var isTutorialShown: Bool
    
    @Storage(suiteName: appStorageGroupSuitname, key: "areInitialCategoriesGenerated", defaultValue: false)
    var areInitialCategoriesGenerated: Bool
    
    @Storage(suiteName: appStorageGroupSuitname, key: "categoriesSortOptionRaw", defaultValue: nil)
    var categoriesSortOrderRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "categoriesSortOrderAscending", defaultValue: true)
    var categoriesSortOrderAscending: Bool
    
    @Storage(suiteName: appStorageGroupSuitname, key: "websitesSortOrderRaw", defaultValue: nil)
    var websitesSortOrderRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "websitesSortOrderAscending", defaultValue: false)
    var websitesSortOrderAscending: Bool
}
