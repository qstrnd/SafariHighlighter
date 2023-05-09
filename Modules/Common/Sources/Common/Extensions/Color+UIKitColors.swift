//
//  Color+UIKitColors.swift
//  
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import SwiftUI

public extension Color {
    
    init(uiColor: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.init(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
    
    // MARK: Rainbow colors
    
    static var systemRed: Color {
        Color(uiColor: .systemRed)
    }
    
    static var systemGreen: Color {
        Color(uiColor: .systemGreen)
    }
    
    static var systemBlue: Color {
        Color(uiColor: .systemBlue)
    }
    
    static var systemOrange: Color {
        Color(uiColor: .systemOrange)
    }
    
    static var systemYellow: Color {
        Color(uiColor: .systemYellow)
    }
    
    static var systemPink: Color {
        Color(uiColor: .systemPink)
    }
    
    static var systemPurple: Color {
        Color(uiColor: .systemPurple)
    }
    
    static var systemTeal: Color {
        Color(uiColor: .systemTeal)
    }
    
    static var systemIndigo: Color {
        Color(uiColor: .systemIndigo)
    }
    
    // MARK: Gray
    
    static var systemGray: Color {
        Color(uiColor: .systemGray)
    }
    
    static var systemGray2: Color {
        Color(uiColor: .systemGray2)
    }
    
    static var systemGray3: Color {
        Color(uiColor: .systemGray3)
    }
    
    static var systemGray4: Color {
        Color(uiColor: .systemGray4)
    }
    
    static var systemGray5: Color {
        Color(uiColor: .systemGray5)
    }
    
    static var systemGray6: Color {
        Color(uiColor: .systemGray6)
    }
    
    // MARK: UI elements
    
    static var label: Color {
        Color(uiColor: .label)
    }
    
    static var secondaryLabel: Color {
        Color(uiColor: .secondaryLabel)
    }
    
    static var tertiaryLabel: Color {
        Color(uiColor: .tertiaryLabel)
    }
    
    static var quaternaryLabel: Color {
        Color(uiColor: .quaternaryLabel)
    }
    
    static var link: Color {
        Color(uiColor: .link)
    }
    
    static var placeholderText: Color {
        Color(uiColor: .placeholderText)
    }
    
    static var separator: Color {
        Color(uiColor: .separator)
    }
    
    static var opaqueSeparator: Color {
        Color(uiColor: .opaqueSeparator)
    }
    
    static var systemBackground: Color {
        Color(uiColor: .systemBackground)
    }
    
    static var secondarySystemBackground: Color {
        Color(uiColor: .secondarySystemBackground)
    }
    
    static var tertiarySystemBackground: Color {
        Color(uiColor: .tertiarySystemBackground)
    }
    
    static var systemGroupedBackground: Color {
        Color(uiColor: .systemGroupedBackground)
    }
    
    static var secondarySystemGroupedBackground: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }
    
    static var tertiarySystemGroupedBackground: Color {
        Color(uiColor: .tertiarySystemGroupedBackground)
    }
    
    static var systemFill: Color {
        Color(uiColor: .systemFill)
    }
    
    static var secondarySystemFill: Color {
        Color(uiColor: .secondarySystemFill)
    }
    
    static var tertiarySystemFill: Color {
        Color(uiColor: .tertiarySystemFill)
    }
    
    static var quaternarySystemFill: Color {
        Color(uiColor: .quaternarySystemFill)
    }
    
}
