//
//  SettingsViewModel.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    // MARK: - Nested
    
    struct Section {
        let title: String?
        let cells: [SettingsCell.Model]
    }
    
    // MARK: - Internal
    
    init(
        coordinator: SettingsCoordinatorProtocol
    ) {
        self.coordinator = coordinator
        
        loadSections()
    }
    
    @Published var sections: [Section] = []
    
    // MARK: Private
    
    private var coordinator: SettingsCoordinatorProtocol
    
    private func loadSections() {
        sections = [
            .init(
                title: Localized.Settings.howToUse,
                cells: [
                    .init(
                        title: Localized.Settings.showTutorial,
                        action: { [unowned self] in
                            coordinator.openTutorial()
                        }
                    )
                ]
            ),
            .init(
                title: Localized.Settings.keepInTouch,
                cells: [
                    .init(
                        icon: .init(
                            name: .asset("twitter-16"),
                            color: Color(hex: "#00acee")
                        ),
                        title: Localized.Settings.followOnTwitter,
                        subtitle: "@qstrnd",
                        action: { [unowned self] in
                            coordinator.openTwitter()
                        }
                    ),
                    .init(
                        icon: .init(
                            name: .system("envelope.fill"),
                            color: .blue
                        ),
                        title: Localized.Settings.contactByEmail,
                        subtitle: "a.yakovlev@qstrnd.com",
                        action: { [unowned self] in
                            coordinator.openEmail()
                        }
                    )
                ]
            ),
            .init(
                title: nil,
                cells: [
                    .init(
                        icon: .init(
                            name: .system("star.fill"),
                            color: .yellow
                        ),
                        title: Localized.Settings.rateOnTheAppStore,
                        action: { [unowned self] in
                            coordinator.openRateOnAppStore()
                        }
                    ),
                    .init(
                        icon: .init(
                            name: .system("hand.raised.fill"),
                            color: .purple
                        ),
                        title: Localized.Settings.termsAndPrivacyPolicy,
                        action: { [unowned self] in
                            coordinator.openTermsAndPrivacyPolicy()
                        }
                    ),
                    .init(
                        icon: .init(
                            name: .system("heart.fill"),
                            color: .pink
                        ),
                        title: Localized.Settings.acknowledgements,
                        action: { [unowned self] in
                            coordinator.openAcknowledgements()
                        }
                    )
                ]
            )
        ]
    }
    
}
