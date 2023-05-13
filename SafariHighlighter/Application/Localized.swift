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
    }
    
    enum Categories {
        static let sortByDefault = NSLocalizedString("categories-sortByDefault", comment: "")
        
        static let sortByNumberOfHighlights = NSLocalizedString("categories-sortByNumberOfHighlights", comment: "")
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
