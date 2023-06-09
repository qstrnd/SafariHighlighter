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
        ZStack {
            Color.systemGroupedBackground
                .ignoresSafeArea()
            
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
                .listStyle(.insetGrouped)
            }
            .frame(maxWidth: 600)
            .navigationBarHidden(true)
        }
    }
    
}
