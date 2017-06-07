//
//  AppDelegate.swift
//  JACoreDataSampleApp
//
//  Created by Jay Chmilewski on 6/6/17.
//  Copyright © 2017 JAKT. All rights reserved.
//

import UIKit
import CoreData
import JACoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context:NSManagedObjectContext!  // Save context in case it's needed in other AppDelegate methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create the main context and pass it into the landing view controller
        let mainContext = createMainContext(modelStoreName: "Model.context", bundles: nil)
        context = mainContext
        RootHelper.setRootController(window: window, storyboardName:"Main", viewControllerID: "InitialNavigationController", moc: mainContext)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

}

