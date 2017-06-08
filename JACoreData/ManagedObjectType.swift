//
//  ManagedObject.swift
//  JAKT_Internal
//
//  Created by Eli Liebman on 1/29/16.
//  Copyright © 2016 JAKT. All rights reserved.
//

import CoreData

public protocol ManagedObjectType: class {
    static var entityName:String {get}
    static var defaultSortDescriptors:[NSSortDescriptor]{get}
}

extension ManagedObjectType where Self: NSManagedObject {
    
    public static var defaultSortDescriptors:[NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest:NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static func findOrCreateInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        guard let obj = findOrFetchInContext(moc: moc, matchingPredicate: predicate) else {
            let newObject: Self = moc.insertObject()
            configure(newObject)
            return newObject
        }
        configure(obj)
        return obj
    }
    
    
    public static func findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let obj = materializedObjectInContext(moc: moc, matchingPredicate: predicate) else {
            return fetchInContext(context: moc) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }
        return obj
    }
    
    public static func fetchInContext(context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Self.entityName)
        configurationBlock(request)
        guard let result = try! context.fetch(request) as? [Self] else { fatalError("Fetched objects have wrong type") }
        return result
    }
    
    public static func countInContext(context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> () = { _ in }) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        configurationBlock(request)

        let result = try! context.count(for: request)
    
        return result
    }
    
    public static func removeAll(moc: NSManagedObjectContext) {
        let toRemove = fetchInContext(context: moc)
        
        // Loop and delete all object
        for object in toRemove {
            moc.delete(object)
        }
    }
    
    public static func materializedObjectInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in moc.registeredObjects where !obj.isFault {
            guard let res = obj as? Self , predicate.evaluate(with: res) else { continue }
            return res
        }
        return nil
    }
    
}
