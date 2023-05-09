//
//  Color+UIKitHex.swift
//  
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import SwiftUI

public extension Color {
    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        
        self.init(uiColor: uiColor)
    }
}
