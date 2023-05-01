//
//  Website.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import Foundation

public struct Website {
    public let name: String
    public let url: URL

    public init(
        name: String,
        url: URL
    ) {
        self.name = name
        self.url = url
    }
}
