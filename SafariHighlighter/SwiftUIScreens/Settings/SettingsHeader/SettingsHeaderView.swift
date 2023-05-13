//
//  SettingsHeaderView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import SwiftUI

struct SettingsHeaderView: View {
    
    @ObservedObject var viewModel: SettingsHeaderViewModel
    
    var body: some View {
        VStack(spacing: 4) {
            appIconImage
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 114, height: 114)
                .cornerRadius(20)
                .padding(.bottom, 8)

            Text(viewModel.fullAppName)
                .font(.headline)

            if let version = viewModel.versionText {
                Text(version)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
    
    private var appIconImage: Image {
        viewModel.iconName
            .map { UIImage(named: $0)! }
            .map { Image(uiImage: $0) }!
    }
}

struct SettingsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHeaderView(viewModel: SettingsHeaderViewModel())
    }
}
