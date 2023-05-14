//
//  Localized.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import Foundation

enum Localized {
    
    enum Tabs {
        
        static let highlights = NSLocalizedString("tabs-highlights", comment: "Highlight tab name")
        
        static let settings = NSLocalizedString("tabs-settings", comment: "Settings tab name")
    }
    
    enum General {
        static let sort = NSLocalizedString("general-sort", comment: "")
        
        static let delete = NSLocalizedString("general-delete", comment: "")
        
        static let yes = NSLocalizedString("general-yes", comment: "")
        
        static let no = NSLocalizedString("general-no", comment: "")
    }
    
    enum Highlights {
        static let deletionConfirmationTitle = NSLocalizedString("highlights-deletionConfirmationTitle", comment: "")

        static let deletionConfirmationSubtitle = NSLocalizedString("highlights-deletionConfirmationSubtitle", comment: "")
    }
    
    enum Sort {
        static let sortByDefault = NSLocalizedString("sort-sortByDefault", comment: "")
        
        static let sortByNumberOfHighlights = NSLocalizedString("sort-sortByNumberOfHighlights", comment: "")
        
        static let sortByCreationDate = NSLocalizedString("sort-sortByCreationDate", comment: "")
        
        static let sortByName = NSLocalizedString("sort-sortByName", comment: "")
        
        static let sortOrder = NSLocalizedString("sort-sortOrder", comment: "")
        
        static let sortAscending = NSLocalizedString("sort-sortAscending", comment: "")
        
        static let sortDescending = NSLocalizedString("sort-sortDescending", comment: "")
        
    }
    
    enum Categories {
        
        static let newCategory = NSLocalizedString("categories-newCategory", comment: "")
        
        static let newCategoryNameHint = NSLocalizedString("categories-newCategoryNameHint", comment: "")

        static let newCategoryColorHint = NSLocalizedString("categories-newCategoryColorHint", comment: "")
        
        static let sortCategories = NSLocalizedString("categories-sortCategories", comment: "")
        
    }
    
    enum Websites {
        
        static let sortWebsites = NSLocalizedString("websites-sortWebsites", comment: "")

    }
    
    enum GroupedHighlights {
        
        static let categories = NSLocalizedString("groupedHighlights-categories", comment: "")
        
        static let websites = NSLocalizedString("groupedHighlights-websites", comment: "")
    }
    
    enum Settings {
        
        static let fullName = NSLocalizedString("settings-fullName", comment: "")
        
        static let version = NSLocalizedString("settings-version", comment: "")
        
        static let howToUse = NSLocalizedString("settings-howToUse", comment: "")
        
        static let showTutorial = NSLocalizedString("settings-showTutorial", comment: "")
        
        static let keepInTouch = NSLocalizedString("settings-keepInTouch", comment: "")
        
        static let followOnTwitter = NSLocalizedString("settings-followOnTwitter", comment: "")
        
        static let contactByEmail = NSLocalizedString("settings-contactByEmail", comment: "")
        
        static let rateOnTheAppStore = NSLocalizedString("settings-rateOnTheAppStore", comment: "")
        
        static let termsAndPrivacyPolicy = NSLocalizedString("settings-termsAndPrivacyPolicy", comment: "")
        
        static let acknowledgements = NSLocalizedString("settings-acknowledgements", comment: "")
        
    }
    
    enum Colors {
        static let red = NSLocalizedString("colors-red", comment: "")
        
        static let orange = NSLocalizedString("colors-orange", comment: "")
        
        static let yellow = NSLocalizedString("colors-yellow", comment: "")
        
        static let green = NSLocalizedString("colors-green", comment: "")
        
        static let blue = NSLocalizedString("colors-blue", comment: "")
        
        static let purple = NSLocalizedString("colors-purple", comment: "")
        
    }
}
