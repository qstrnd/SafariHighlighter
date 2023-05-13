//
//  CGSize+Square.swift
//  
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import Foundation

public extension CGSize {
    
    init(square: CGFloat) {
        self.init(width: square, height: square)
    }
    
}
