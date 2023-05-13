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
}
