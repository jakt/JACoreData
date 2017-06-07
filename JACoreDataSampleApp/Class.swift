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

public class Class: ManagedObject {
    @NSManaged public private(set) var name:String
    @NSManaged public private(set) var professor:String?
    // Relationships
    @NSManaged public private(set) var students:Set<Student>?
    
    public static func insertIntoContext(moc: NSManagedObjectContext, name:String?, professor:String?, students:[Student]?) -> Class? {
        guard let name = name else {
                return nil
        }
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        let classObj = Class.findOrCreateInContext(moc: moc, matchingPredicate: predicate) { (classObj) in
            classObj.name = name
            classObj.professor = professor
            
            // Relationships
            students?.forEach({ classObj.students?.insert($0) })
        }
        
        return classObj
    }
}

extension Class: ManagedObjectType {
    public static var entityName: String {
        return "Class"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}
