//
//  Student.swift
//  JACoreData
//
//  Created by Jay Chmilewski on 6/7/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import Foundation
import CoreData
import JACoreData

public class Class: NSManagedObject {
    @NSManaged public private(set) var name:String
    @NSManaged public private(set) var professor:String?
    // Relationships
    @NSManaged public private(set) var students:Set<Student>?
    
    /// This function create or updates a Class object in the core data stack
    /// Notice that the context needs to be saved after this method is called.
    public static func insertIntoContext(moc: NSManagedObjectContext, name:String?, professor:String?, students:[Student]?) -> Class? {
        guard let name = name else {
                return nil
        }
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        // Find an existing object based on the predicate. If none exists, create a new one.
        let classObj = Class.findOrCreateInContext(moc: moc, matchingPredicate: predicate) { (classObj) in
            classObj.name = name
            classObj.professor = professor
            
            // Relationships
            students?.forEach({ classObj.students?.insert($0) })
        }
        
        return classObj
        
    }
}

// All ManagedObject should adhere to the ManagedObjectType protocol
extension Class: ManagedObjectType {
    public static var entityName: String {
        return "Class"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}
