//
//  persistanceExecutorFactory.swift
//
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import UIKit

public final class persistanceExecutorFactory: NSObject {
    private var persistentManager: PersistentManager?

    private let initialStoreOptions: PersistentStoreOptions

    public init(initialStoreOptions: PersistentStoreOptions) {
        self.initialStoreOptions = initialStoreOptions
    }

    public func getSharedpersistanceExecutor() -> persistanceExecutor {
        if let persistentManager = persistentManager {
            return persistentManager
        }

        let persistentManager = PersistentManager(
            storeOptions: initialStoreOptions,
            loadPersistentStoreImmediately: true
        )

        self.persistentManager = persistentManager

        return persistentManager
    }
}
