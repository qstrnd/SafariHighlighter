//
//  UIView+Autolayout.swift
//  
//
//  Created by Andrey Yakovlev on 14.05.2023.
//

import UIKit

public extension UIView {
    
    func addSubviewAlignedToEdges(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor),
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
