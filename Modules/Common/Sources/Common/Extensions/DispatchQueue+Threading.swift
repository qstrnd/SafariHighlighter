//
//  DispatchQueue+Threading.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import Foundation

public extension DispatchQueue {
    static func performOnMain(_ block: @escaping (() -> Void)) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
