//
//  SecondModelViewController.swift
//  JACoreData
//
//  Created by Jay Chmilewski on 6/7/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import UIKit
import CoreData
import JACoreData

class AddClassViewController: UIViewController, ManagedObjectContextSettable {

    // Property required in all ManagedObjectContextSettable types. must be set before view controller is initialized
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet var textFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let studentStrings = textFields[2].text?.components(separatedBy: ", ")
        let potentialStudentObjects = studentStrings?.map({ (string) -> Student? in
            let predicate = NSPredicate(format: "name == %@", string)
            return Student.findOrFetchInContext(moc: self.managedObjectContext, matchingPredicate: predicate)
        })
        let validStudents = potentialStudentObjects?.flatMap({ $0 }) // Removes all nil values
        
        if let _ = Class.insertIntoContext(moc: managedObjectContext, name: textFields[0].text, professor: textFields[1].text, students: validStudents) {
            _ = managedObjectContext.saveOrRollback()
            navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Enter valid info to create a class", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }

}
