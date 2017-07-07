
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform: iOS 8+](https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat)
[![Language: Swift 3](https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)

JACoreData is a simple wrapper for Core Data objects in Swift iOS projects.


## Installation
JACoreData is designed to be installed using Carthage.

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate JACoreData into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "jakt/JACoreData.git"
```

Run `carthage` to build the framework and drag the built `JACoreData.framework` into your Xcode project.

## Requirements

| JACoreData Version | Minimum iOS Target |
|:--------------------:|:---------------------------:|
| 0.x | iOS 9 |
| 1.x | iOS 8 |

---

## Usage

### Creating the main context

To create the main context you call `createMainContext(modelStoreName: String, bundles: [NSBundle]?)` This function sets up the Core Data stack and returns the main context.

### Creating ManagedObjectTypes

The `ManagedObjectType` protocol can be applied to any `NSManagedObject` and simply requires the settings of the `entityName` variable. You can also optionally implement the `defaultSortDescriptors` variable for easier use with an NSFetchedResultsController.

```swift 
extension User: ManagedObjectType {
    public static var entityName: String {
        return "User"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}
```

### Inserting a Managed Object

Inserting an object that conforms to the `ManagedObjectType` protocol into the the mananged object context is done by simply calling `insertObject()`.

```swift 
let moc:NSManagedObjectContext = ...
let newUser: User = moc.insertObject()
```

### Saving Objects

To save changes to the context you can use `saveOrRollback()` but incapsulating the changes in the `performChanges(block:()->())` block is preferred. This function attempts to save all the changes asynchronously and if the command fails, will rollback the changes.


### Fetching Objects

To fetch a single `NSManagedObject` object that conforms to the `ManagedObjectType` protocol, use `findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self?`.

You can also use `findOrCreateInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self` to find or create an object if it doesn't exist.

To fetch more than one object, use `fetchInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self]`.



