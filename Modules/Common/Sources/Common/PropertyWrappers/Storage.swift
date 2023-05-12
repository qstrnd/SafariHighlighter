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
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
