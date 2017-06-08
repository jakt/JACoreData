//
//  JACoreDataSampleAppTests.swift
//  JACoreDataSampleAppTests
//
//  Created by Jay Chmilewski on 6/7/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import XCTest
import CoreData
import JACoreData
@testable import JACoreDataSampleApp

class CoreDataStackTests: XCTestCase {
    
    var context:NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        context = JACoreData.createInMemoryMainContext(modelStoreName: "testing", bundles: nil)  // Model only exists in memory, wont persists
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContextCreation() {
        let mainContext = createMainContext(modelStoreName: "main.model", bundles: nil)
        Student.removeAll(moc: mainContext)
        _ = mainContext.saveOrRollback()
        _ = Student.insertIntoContext(moc: mainContext, name: "main", age: "99", classes: nil)
        let mainStudents = Student.fetchInContext(context: mainContext)
        XCTAssertEqual(mainStudents.count, 1)
        XCTAssertEqual(mainStudents.first!.age, 99)
        
        let backgroundContext = createBackgroundContext(modelStoreName: "background.model", bundles: nil)
        Student.removeAll(moc: backgroundContext)
        _ = backgroundContext.saveOrRollback()
        _ = Student.insertIntoContext(moc: backgroundContext, name: "background", age: "88", classes: nil)
        let backgroundStudents = Student.fetchInContext(context: backgroundContext)
        XCTAssertEqual(backgroundStudents.count, 1)
        XCTAssertEqual(backgroundStudents.first!.age, 88)
        
        let memoryContext = createInMemoryMainContext(modelStoreName: "memory.model", bundles: nil)
        Student.removeAll(moc: memoryContext)
        _ = memoryContext.saveOrRollback()
        _ = Student.insertIntoContext(moc: memoryContext, name: "memory", age: "77", classes: nil)
        let memoryStudents = Student.fetchInContext(context: memoryContext)
        XCTAssertEqual(memoryStudents.count, 1)
        XCTAssertEqual(memoryStudents.first!.age, 77)
    }
    
    func testDataSaving() {
        // saveOrRollback is tested in testContextCreation code above
        
        let savingExpectation = expectation(description: "Saving")
        Student.removeAll(moc: context)
        context.performChanges {
            _ = Student.insertIntoContext(moc: self.context, name: "test", age: "88", classes: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let students = Student.fetchInContext(context: self.context)
            XCTAssertEqual(students.count, 1)
            XCTAssertEqual(students.first!.name, "test")
            savingExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTAssertTrue(false)
            }
        }
    }
    
}
