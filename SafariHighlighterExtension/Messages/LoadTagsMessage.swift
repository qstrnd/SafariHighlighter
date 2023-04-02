//
//  LoadTagsMessage.swift
//  SafariHighlighterExtension
//
//  Created by Andrey Yakovlev on 01.04.2023.
//

import Foundation
import Common

struct Person: StringDictionaryInterchangeable {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    init?(from dictionary: [String : String]) {
        guard let name = dictionary["name"], let ageString = dictionary["age"], let age = Int(ageString) else {
            return nil
        }

        self.name = name
        self.age = age
    }

    func asDictionary() -> [String : String] {
        return ["name": name, "age": String(age)]
    }
}
