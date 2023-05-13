//
//  UIEdgetInsets.swift
//  
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit

public extension UIEdgeInsets {
    
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
}
