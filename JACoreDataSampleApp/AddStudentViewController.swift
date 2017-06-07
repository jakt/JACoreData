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

class AddStudentViewController: UIViewController, ManagedObjectContextSettable {
    
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
        let classStrings = textFields[2].text?.components(separatedBy: ", ")
        let potentialClassObjects = classStrings?.map({ (string) -> Class? in
            let predicate = NSPredicate(format: "name == %@", string)
            return Class.findOrFetchInContext(moc: self.managedObjectContext, matchingPredicate: predicate)
        })
        let validClasses = potentialClassObjects?.flatMap({ $0 }) // Removes all nil values
        
        if let _ = Student.insertIntoContext(moc: managedObjectContext, name: textFields[0].text, age: textFields[1].text, classes: validClasses) {
            _ = managedObjectContext.saveOrRollback()
            navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Enter valid info to create a student", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
