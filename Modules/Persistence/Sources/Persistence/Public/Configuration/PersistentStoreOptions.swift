//
//  PersistentStoreOptions.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import Foundation

public struct PersistentStoreOptions {

    public let isPersistenceEnabled: Bool
    public let isCloudSyncEnabled: Bool

    public init(
        isPersistenceEnabled: Bool,
        isCloudSyncEnabled: Bool
    ) {
        self.isPersistenceEnabled = isPersistenceEnabled
        self.isCloudSyncEnabled = isCloudSyncEnabled
    }
}
