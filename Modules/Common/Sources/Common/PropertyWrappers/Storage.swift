//
//  Storage.swift
//  
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import Foundation

@propertyWrapper
public struct Storage<T> {
    
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults
    
    public init(suiteName: String, key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = UserDefaults(suiteName: suiteName)!
    }
    
    public var wrappedValue: T {
        get {
            userDefaults.value(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
