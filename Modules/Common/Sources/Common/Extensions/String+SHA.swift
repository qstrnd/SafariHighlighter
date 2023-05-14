//
//  String+SHA.swift
//  
//
//  Created by Andrey Yakovlev on 14.05.2023.
//

import Foundation
import CryptoKit

public extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        let hashed = SHA256.hash(data: data)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
