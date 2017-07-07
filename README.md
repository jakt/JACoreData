
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform: iOS 8+](https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat)
[![Language: Swift 3](https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)

JACoreData is a simple wrapper for Core Data objects in swift iOS projects. While fairly lightweight, this library makes fetching, creating, and saving NSManagedObjects easier and cleaner. Simply conform your already laid out `NSManagedObject` files to the `ManagedObjectType` protocol in JACoreData and you instantly gain access to multiple convenience methods.

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

### Creating ManagedObjectTypes

The `ManagedObjectType` protocol can be applied to any `NSManagedObject` and simply requires the setting of the `entityName` variable. You can also optionally implement the `defaultSortDescriptors` variable for easier use with an NSFetchedResultsController.

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
### Fetching Objects

To fetch a single `NSManagedObject` object that conforms to the `ManagedObjectType` protocol, use `findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self?`. This will return nil if no object in the database matches the given predicate.

To fetch more than one object, use `fetchInContext(context: NSManagedObjectContext, configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self]`.

### Inserting a Managed Object

Inserting into the mananged object context is done by simply calling `insertObject()`. Sometimes, when inserting new data, you may not know whether the object has been saved before. For these situations, use `findOrCreateInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self`. This acts very similarly to `findOrFetchInContext` but will create an object if no object is found in the database to match the given predicate.

```swift 
let moc:NSManagedObjectContext = ...

// Insert directly
let newPost: Post = moc.insertObject()

// Insert when object may already exist in the database
let predicate = NSPredicate(format: "id == %@", "3003")
let newOrExistingPost = Post.findOrCreateInContext(moc: moc, matchingPredicate: predicate) { (editableObj) in
    // Configure the editableObj here...
}

```

### Saving Objects

Once all changes have been made, you can save the context by calling `saveOrRollback()`. This function attempts to save all the changes, but if the command fails, it will rollback the changes. To perform a specific set of changes to be saved to the context right away, `performChanges(block:()->())` is preferred. Here, all of your changes are wrapped in a single block. After they're performed the context is saved.


### Creating the Main Context

To create the main context, you call `createMainContext(modelStoreName: String, bundles: [NSBundle]?)`. This function sets up the Core Data stack and returns the main context. This would typically be called in the `AppDelegate` and then passed into the landing view controller.

