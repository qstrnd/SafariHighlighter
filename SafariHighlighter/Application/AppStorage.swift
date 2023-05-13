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
    
    // MARK: Initial categories
    
    @Storage(suiteName: appStorageGroupSuitname, key: "initialCategoriesIdRed", defaultValue: nil)
    private var initialCategoriesIdRedRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "initialCategoriesIdOrange", defaultValue: nil)
    private var initialCategoriesIdOrangeRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "initialCategoriesIdYellow", defaultValue: nil)
    private var initialCategoriesIdYellowRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "initialCategoriesIdGreen", defaultValue: nil)
    private var initialCategoriesIdGreenRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "initialCategoriesIdBlue", defaultValue: nil)
    private var initialCategoriesIdBlueRaw: String?
    
    @Storage(suiteName: appStorageGroupSuitname, key: "initialCategoriesIdPurple", defaultValue: nil)
    private var initialCategoriesIdPurpleRaw: String?
    
    
    var initialCategoriesIdRed: UUID? {
        get {
            guard let rawValue = initialCategoriesIdRedRaw else { return nil }
            return UUID(uuidString: rawValue)
        }
        set {
            initialCategoriesIdRedRaw = newValue?.uuidString
        }
    }
    
    var initialCategoriesIdOrange: UUID? {
        get {
            guard let rawValue = initialCategoriesIdOrangeRaw else { return nil }
            return UUID(uuidString: rawValue)
        }
        set {
            initialCategoriesIdOrangeRaw = newValue?.uuidString
        }
    }
    
    var initialCategoriesIdYellow: UUID? {
        get {
            guard let rawValue = initialCategoriesIdYellowRaw else { return nil }
            return UUID(uuidString: rawValue)
        }
        set {
            initialCategoriesIdYellowRaw = newValue?.uuidString
        }
    }
    
    var initialCategoriesIdGreen: UUID? {
        get {
            guard let rawValue = initialCategoriesIdGreenRaw else { return nil }
            return UUID(uuidString: rawValue)
        }
        set {
            initialCategoriesIdGreenRaw = newValue?.uuidString
        }
    }
    
    var initialCategoriesIdBlue: UUID? {
        get {
            guard let rawValue = initialCategoriesIdBlueRaw else { return nil }
            return UUID(uuidString: rawValue)
        }
        set {
            initialCategoriesIdBlueRaw = newValue?.uuidString
        }
    }
    
    var initialCategoriesIdPurple: UUID? {
        get {
            guard let rawValue = initialCategoriesIdPurpleRaw else { return nil }
            return UUID(uuidString: rawValue)
        }
        set {
            initialCategoriesIdPurpleRaw = newValue?.uuidString
        }
    }
    
}
