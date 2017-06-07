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

public class Student: ManagedObject {
    @NSManaged public private(set) var name:String
    @NSManaged public private(set) var age:Int64
    // Relationships
    @NSManaged public private(set) var classes:Set<Class>?
    
    /// This function create or updates a Student object in the core data stack
    /// Notice that the context needs to be saved after this method is called.
    public static func insertIntoContext(moc: NSManagedObjectContext, name:String?, age:String?, classes:[Class]?) -> Student? {
        guard let name = name,
            let age = age,
            let ageInt = Int(age)
            else {
                return nil
        }
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        let student = Student.findOrCreateInContext(moc: moc, matchingPredicate: predicate) { (student) in
            student.name = name
            student.age = Int64(ageInt)

            // Relationships
            classes?.forEach({ student.classes?.insert($0) })
        }
        
        return student
    }
}

// All ManagedObject should adhere to the ManagedObjectType protocol
extension Student: ManagedObjectType {
    public static var entityName: String {
        return "Student"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}
