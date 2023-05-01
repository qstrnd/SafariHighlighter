//
//  PersistenceExecutor.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import CoreData

public protocol PersistenceExecutor: PersistenceOperationsExecuting, PersistenceOptionsConfigurable {}

public protocol PersistenceOperationsExecuting: AnyObject {
    func execute(_ block: @escaping (NSManagedObjectContext) -> Void)
}

public protocol PersistenceOptionsConfigurable: AnyObject {
    var storeOptions: PersistentStoreOptions { get set }
}
