//
//  ManagedObjectTests.swift
//  JACoreData
//
//  Created by Jay Chmilewski on 6/7/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import XCTest
import CoreData
import JACoreData
@testable import JACoreDataSampleApp

class ManagedObjectTests: XCTestCase {
    
    var context:NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        context = JACoreData.createInMemoryMainContext(modelStoreName: "testing", bundles: nil)  // Model only exists in memory, wont persists
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSortedFetch() {
        // Default sort descriptor for student is the "name" tag.
        _ = Student.insertIntoContext(moc: context, name: "one", age: "1", classes: nil)
        _ = Student.insertIntoContext(moc: context, name: "two", age: "2", classes: nil)
        _ = Student.insertIntoContext(moc: context, name: "three", age: "3", classes: nil)
        _ = Student.insertIntoContext(moc: context, name: "four", age: "4", classes: nil)
        _ = Student.insertIntoContext(moc: context, name: "five", age: "5", classes: nil)

        let fetchRequest = Student.sortedFetchRequest
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        // Will be sorted alphabetically by default
        let a = fetchedResultsController.fetchedObjects![0]
        XCTAssertEqual(a.name, "five")
        let b = fetchedResultsController.fetchedObjects![1]
        XCTAssertEqual(b.name, "four")
        let c = fetchedResultsController.fetchedObjects![2]
        XCTAssertEqual(c.name, "one")
        let d = fetchedResultsController.fetchedObjects![3]
        XCTAssertEqual(d.name, "three")
        let e = fetchedResultsController.fetchedObjects![4]
        XCTAssertEqual(e.name, "two")
    }
    
    func testFetchingAndCreation() {
        // Make sure we start on a clean context
        Student.removeAll(moc: context)
        _ = context.saveOrRollback()
        XCTAssertEqual(Student.countInContext(context: context), 0)

        // Create a new object
        let name = "smith"
        let student1 = Student.insertIntoContext(moc: context, name: name, age: "15", classes: nil)  // The underlying function used in insertIntoContext is findOrCreateInContext
        XCTAssertEqual(Student.countInContext(context: context), 1)
        XCTAssertEqual(student1?.age, 15)
        
        // Call same method and make sure the existing object is updated and a new object isn't being created
        let student2 = Student.insertIntoContext(moc: context, name: name, age: "99", classes: nil)  // The underlying function used in insertIntoContext is findOrCreateInContext
        XCTAssertEqual(Student.countInContext(context: context), 1)
        XCTAssertEqual(student2?.age, 99)  // Make sure properties are updated correctly
        
        XCTAssertEqual(Student.countInContext(context: context), Student.fetchInContext(context: context).count)

        var predicate = NSPredicate(format: "name == %@", name)
        let result = Student.findOrFetchInContext(moc: context, matchingPredicate: predicate)
        XCTAssertEqual(result?.age, 99)
        predicate = NSPredicate(format: "name == %@", "new name")
        let newResult = Student.findOrFetchInContext(moc: context, matchingPredicate: predicate)  // This wont create a new object
        XCTAssertNil(newResult)
        
        // Save current state
        _ = context.saveOrRollback()

        // Test object deletion
        Student.removeAll(moc: context)
        _ = context.saveOrRollback()
        XCTAssertEqual(Student.countInContext(context: context), 0)
    }
}
