//
//  PersistenceExecutor.swift
//  
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import CoreData

public protocol PersistenceExecutor: AnyObject {
    func execute(_ block: @escaping (NSManagedObjectContext) -> Void)
}
