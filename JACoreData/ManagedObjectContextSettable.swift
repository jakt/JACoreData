//
//  ManagedObjectContextSettable.swift
//  JAKT_Internal
//
//  Created by Eli Liebman on 1/29/16.
//  Copyright © 2016 JAKT. All rights reserved.
//

import CoreData

public protocol ManagedObjectContextSettable: class {
    var managedObjectContext: NSManagedObjectContext!{get set}
}