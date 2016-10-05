//
//  CoreDataStack.swift
//  Geofilter Creator
//
//  Created by Eli Liebman on 3/30/16.
//  Copyright © 2016 JAKT. All rights reserved.
//

import CoreData
import UIKit


public func createMainContext(modelStoreName:String, bundles:[NSBundle]?) -> NSManagedObjectContext {
    let storeURL = NSURL.documentsURL.URLByAppendingPathComponent(modelStoreName)
    
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {fatalError("model not found")}
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    let options = [NSInferMappingModelAutomaticallyOption:true,
                   NSMigratePersistentStoresAutomaticallyOption: true]
    try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}

public func createBackgroundContext(modelStoreName:String, bundles:[NSBundle]?) -> NSManagedObjectContext {
    let storeURL = NSURL.documentsURL.URLByAppendingPathComponent(modelStoreName)
    
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {fatalError("model not found")}
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    let options = [NSInferMappingModelAutomaticallyOption:true,
                   NSMigratePersistentStoresAutomaticallyOption: true]
    
    try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}

public func createInMemoryMainContext(modelStoreName:String, bundles:[NSBundle]?) -> NSManagedObjectContext {
    let storeURL = NSURL.documentsURL.URLByAppendingPathComponent(modelStoreName)
    
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {fatalError("model not found")}
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    let options = [NSInferMappingModelAutomaticallyOption:true,
                   NSMigratePersistentStoresAutomaticallyOption: true]
    
    try! psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: storeURL, options: options)
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}

extension NSURL {
    
    static func temporaryURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)!
    }
    
    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
}

extension NSManagedObjectContext {
    public func insertObject<A:ManagedObject where A:ManagedObjectType>() -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else {fatalError("wrong object type - Type should be \(A.entityName))")}
        return obj
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performChanges(block:()->()){
        performBlock { 
            block()
            self.saveOrRollback()
        }
    }
}
