//
//  DictionaryRepresentable.swift
//  
//
//  Created by Andrey Yakovlev on 01.04.2023.
//

import Foundation

public protocol StringDictionaryRepresentable {
    func asDictionary() -> [String: String]
}

public protocol StringDictionaryInitializable {
    init?(from dictionary: [String: String])
}

public protocol StringDictionaryInterchangeable: StringDictionaryRepresentable, StringDictionaryInitializable {}



extension NSDictionary: StringDictionaryRepresentable {

    public func asDictionary() -> [String : String] {
        return self as? [String: String] ?? [:]
    }

}
