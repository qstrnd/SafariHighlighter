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
                title: "How To Use",
                cells: [
                    .init(
                        title: "Show Tutorial",
                        action: { [unowned self] in
                            coordinator.openTutorial()
                        }
                    )
                ]
            ),
            .init(
                title: "Keep In Touch",
                cells: [
                    .init(
                        icon: .init(
                            name: .asset("twitter-16"),
                            color: Color(hex: "#00acee")
                        ),
                        title: "Follow on Twitter",
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
                        title: "Contact by Email",
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
                        title: "Rate on the App Store",
                        action: { [unowned self] in
                            coordinator.openRateOnAppStore()
                        }
                    ),
                    .init(
                        icon: .init(
                            name: .system("hand.raised.fill"),
                            color: .purple
                        ),
                        title: "Terms & Privacy Policy",
                        action: { [unowned self] in
                            coordinator.openTermsAndPrivacyPocily()
                        }
                    ),
                    .init(
                        icon: .init(
                            name: .system("heart.fill"),
                            color: .pink
                        ),
                        title: "Acknowledgments",
                        action: { [unowned self] in
                            coordinator.openAcknowledgements()
                        }
                    )
                ]
            )
        ]
    }
    
}
