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
        VStack(spacing: 0) {
            List {
                SettingsHeaderView(viewModel: SettingsHeaderViewModel())
                
                ForEach(viewModel.sections, id: \.title) { section in
                    let cells = ForEach(section.cells, id: \.title) { cellModel in
                        SettingsCell(model: cellModel)
                    }
                    
                    if let title = section.title {
                        Section(header: Text(title)) {
                            cells
                        }
                    } else {
                        Section {
                            cells
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(coordinator: SettingsCoordinator()))
    }
}
