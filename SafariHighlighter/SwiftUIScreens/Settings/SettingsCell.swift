//
//  SettingsCell.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import SwiftUI

struct SettingsCell: View {
    
    struct Model {
        
        struct Icon {
            
            enum IconName {
                case system(String)
                case asset(String)
            }
            
            let name: IconName
            let color: Color?
        }
        
        let icon: Icon?
        let title: String
        let subtitle: String?
        let action: (() -> Void)?
        
        init(
            icon: Icon? = nil,
            title: String,
            subtitle: String? = nil,
            action: (() -> Void)? = nil
        ) {
            self.icon = icon
            self.title = title
            self.subtitle = subtitle
            self.action = action
        }
    }
    
    @State var model: Model
    
    var body: some View {
        HStack(spacing: 20) {
            if let icon = model.icon {
                iconView(for: icon)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                
                if let subtitle = model.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if model.action != nil {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.separator)
            }
        }.onTapGesture {
            model.action?()
        }
    }
    
    // MARK: - Private
    
    private var iconColor: Color {
        model.icon?.color ?? .placeholderText
    }
    
    private func iconView(for iconModel: Model.Icon) -> some View {
        switch iconModel.name {
        case .asset(let name):
            return Image(name)
                .renderingMode(.template)
                .foregroundColor(iconColor)
                .frame(width: 16, height: 16)
                .padding(.leading, 6)
        case .system(let systemName):
            return Image(systemName: systemName)
                .foregroundColor(iconColor)
                .frame(width: 16, height: 16)
                .padding(.leading, 6)
        }
    }
    
}
