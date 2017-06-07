//
//  ViewController.swift
//  JACoreDataSampleApp
//
//  Created by Jay Chmilewski on 6/6/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import UIKit
import CoreData
import JACoreData

class InitialViewController: UIViewController, ManagedObjectContextSettable {

    // Property required in all ManagedObjectContextSettable types. must be set before view controller is initialized
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    // MARK: -fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<Student> = {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        
        // Configure Sort Descriptors
        let sortDescriptors = Student.defaultSortDescriptors
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Basic UI setup
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        configure(for: nil)
        
        fetch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Make sure to set the managed object context in prepareForSegue when needed
        if segue.identifier == "addClassSegue", let classVC = segue.destination as? AddClassViewController {
            classVC.managedObjectContext = self.managedObjectContext
        } else if segue.identifier == "addStudentSegue", let studentVC = segue.destination as? AddStudentViewController {
            studentVC.managedObjectContext = self.managedObjectContext
        }
    }

    func fetch () {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func configure(for student:Student?) {
        guard let student = student else {
            nameLabel.text = nil
            ageLabel.text = nil
            classLabel.text = nil
            return
        }
        
        nameLabel.text = student.name
        ageLabel.text = "\(student.age)"
        var classesString:String?
        student.classes?.forEach({(classObj) in
            if let valid = classesString {
                classesString = valid + ", " + classObj.name
            } else {
                classesString = classObj.name
            }
        })
        classLabel.text = classesString
    }
}

// MARK: - Extensions for TableView

extension InitialViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let students = fetchedResultsController.fetchedObjects else { return 0 }
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        let student = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = student.name
        return cell
    }
}

extension InitialViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = fetchedResultsController.object(at: indexPath)
        configure(for: student)

    }
}

extension InitialViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let student = fetchedResultsController.object(at: indexPath)
                cell.textLabel?.text = student.name
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}
