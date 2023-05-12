//
//  SettingsView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import SwiftUI
import Common

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    SettingsHeaderView()
                    
                    ForEach(viewModel.sections, id: \.title) { section in
                        Section(header: Text(section.title ?? "")) {
                            ForEach(section.cells, id: \.title) { cellModel in
                                SettingsCell(model: cellModel)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
}

struct SettingsHeaderView: View {
    
    private var iconFileName: String? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last
        else { return nil }
        return iconFileName
    }
    
    private var appIconImage: Image {
        iconFileName
            .map { UIImage(named: $0)! }
            .map { Image(uiImage: $0) }!
    }

    var body: some View {
        VStack(spacing: 4) {
            appIconImage
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 114, height: 114)
                .cornerRadius(20)
                .padding(.bottom, 8)

            Text("Highlighter for Safari")
                .font(.headline)

            if let version = versionText {
                Text(version)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }

    private var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    private var buildNumber: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    private var versionText: String? {
        guard let appVersion else { return nil }

        var text = "Version \(appVersion)"

        if let buildNumber = buildNumber {
            text += " (\(buildNumber))"
        }

        return text
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(coordinator: SettingsCoordinator()))
    }
}
