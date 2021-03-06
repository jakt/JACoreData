//
//  RootHelper.swift
//  JACoreData
//
//  Created by Jay Chmilewski on 6/6/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import UIKit
import CoreData
import JACoreData

// MARK: - Root helper
class RootHelper{
    // Sets the root view controller for the app and assigns the managed object context to it
    class func setRootController(window: UIWindow?, storyboardName: String, viewControllerID: String, moc: NSManagedObjectContext){
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: viewControllerID)
        setMOCController(window: window, moc: moc)
    }
    
    // Sets the base controllers "managedObjectContext" variable. If it hits a nav controller it sets its first view controller.
    class func setMOCController(window: UIWindow?, moc: NSManagedObjectContext){
        // Navigations Controller
        if let vc = window?.rootViewController as? ManagedObjectContextSettable { // Controller
            vc.managedObjectContext = moc
        } else if let rootController = window?.rootViewController as? UINavigationController, let vc = rootController.viewControllers.first as? ManagedObjectContextSettable {
            vc.managedObjectContext = moc
        }
    }
}
