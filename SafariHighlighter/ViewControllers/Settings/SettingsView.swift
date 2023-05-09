//
//  SettingsView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import SwiftUI
import Common

struct SettingsView: View {
    
    @State private var isShowingTutorialView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    HeaderView()
                    
                    Section(header: Text("How To Use")) {
                        NavigationLink(destination: TutorialView(), isActive: $isShowingTutorialView) {
                            MyListCell(title: "Show tutorial", showChevron: false)
                                .onTapGesture {
                                    isShowingTutorialView = true
                                }
                        }
                    }
                    
                    Section(header: Text("Keep In Touch")) {
                        MyListCell(iconName: "twitter-16", iconColor: Color(hex: "#00acee")!, title: "Follow on Twitter", subtitle: "@qstrnd")
                            .onTapGesture {
                                let twitterUrl = URL(string: "https://twitter.com/qstrnd")!
                                UIApplication.shared.open(twitterUrl)
                            }
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = "@qstrnd"
                                }) {
                                    Text("Copy")
                                }
                            }
                        
                        MyListCell(systemIconName: "envelope.fill", iconColor: .blue, title: "Contact by Email", subtitle: "a.yakovlev@qstrnd.com")
                            .onTapGesture {
                                let email = "a.yakovlev@qstrnd.com"
                                let subject = "Highlighter%20for%20Safari"
                                
                                let mailtoString = "mailto:\(email)?subject=\(subject)"
                                let mailtoUrl = URL(string: mailtoString)!
                                
                                UIApplication.shared.open(mailtoUrl)
                            }
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = "a.yakovlev@qstrnd.com"
                                }) {
                                    Text("Copy")
                                }
                            }
                    }
                    
                    Section {
                        MyListCell(systemIconName: "star.fill", iconColor: .yellow, title: "Rate on the App Store")
                            .onTapGesture {
                                // TODO: Also use SKStoreProductViewController
                                let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/idXXX")!
                                
                                UIApplication.shared.open(appStoreUrl)
                            }
                        
                        MyListCell(systemIconName: "hand.raised.fill", iconColor: .purple, title: "Terms & Privacy Policy")
                            .onTapGesture {
                                let privacy = URL(string: "https://qstrnd.com/apps/safariHighlighter/legal")!
                                
                                UIApplication.shared.open(privacy)
                            }
                        
                        MyListCell(systemIconName: "heart.fill", iconColor: .pink, title: "Acknowledgments")
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct HeaderView: View {

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "square.grid.3x3.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)

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

struct MyListCell: View {

    var iconName: String?
    var systemIconName: String?
    var iconColor: Color = .label
    
    let title: String
    var subtitle: String?
    var showChevron: Bool = true

    var body: some View {
        HStack(spacing: 20) {
            if let iconName = iconName {
                Image(iconName)
                    .renderingMode(.template)
                    .foregroundColor(iconColor)
                    .frame(width: 16, height: 16)
                    .padding(.leading, 6)
            }
            if let iconName = systemIconName {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .frame(width: 16, height: 16)
                    .padding(.leading, 6)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if showChevron {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.separator)
            }
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
