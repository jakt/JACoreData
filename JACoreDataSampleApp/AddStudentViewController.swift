//
//  AddStudentViewController.swift
//  JACoreData
//
//  Created by Jay Chmilewski on 6/7/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import UIKit
import CoreData
import JACoreData

/// Simple View Controller used to add class objects to Core Data.
/// And students entered in the "students" section need to be seperated by a comma and space and must match an existing student object's name or it will be ignored.

class AddStudentViewController: UIViewController, ManagedObjectContextSettable {
    
    // Property required in all ManagedObjectContextSettable types. must be set before view controller is initialized
    var managedObjectContext: NSManagedObjectContext!
    
    // Storyboard textField references, saved from top to bottom
    @IBOutlet var textFields: [UITextField]!
    
    // Create a new Student with entered info.
    // If a Student object exists with the same name, it will update the existing object instead of creating a new one.
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // Find all class core data objects that match the text entry from the "Classes" text field
        let classStrings = textFields[2].text?.components(separatedBy: ", ")
        let potentialClassObjects = classStrings?.map({ (string) -> Class? in
            let predicate = NSPredicate(format: "name == %@", string)
            return Class.findOrFetchInContext(moc: self.managedObjectContext, matchingPredicate: predicate)
        })
        let validClasses = potentialClassObjects?.flatMap({ $0 }) // Removes all nil values
        
        // Create or update a Student object with the info
        if let _ = Student.insertIntoContext(moc: managedObjectContext, name: textFields[0].text, age: textFields[1].text, classes: validClasses) {
            // Object created, save the managedObjectContext and pop back to the initial view controller
            _ = managedObjectContext.saveOrRollback()
            navigationController?.popViewController(animated: true)
        } else {
            // Object creation failed because either the name field was left blank or the age field wasn't a valid integer
            let alertController = UIAlertController(title: "Enter valid info to create a student", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
