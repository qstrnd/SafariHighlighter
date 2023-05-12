//
//  SettingsHeaderViewModel.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit

final class SettingsHeaderViewModel: ObservableObject {

    // MARK: - Internal
    
    @Published var versionText: String?
    @Published var iconName: String?
    
    
    init() {
        iconName = iconNameResourceString
        updateVersionText()
    }
    
    // MARK: - Private
    
    // MARK: Version and Build
    
    private var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    private var buildNumber: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    private func updateVersionText() {
        guard let appVersion else {
            versionText = nil
            return
        }

        var versionText = "Version \(appVersion)"

        if let buildNumber = buildNumber {
            versionText += " (\(buildNumber))"
        }

        self.versionText = versionText
    }
    
    // MARK: App Icon
    
    private var iconNameResourceString: String? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last
        else { return nil }
        return iconFileName
    }
}
