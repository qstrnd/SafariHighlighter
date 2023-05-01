//
//  PersistanceExecutorFactory.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import UIKit

public final class PersistanceExecutorFactory: NSObject {
    private var persistanceExecutor: PersistenceExecutor?


    public func getSharedPersistanceExecutor(options: PersistentStoreOptions) -> PersistenceExecutor {

        if let persistanceExecutor = persistanceExecutor {
            return persistanceExecutor
        }



        let
    }
}
