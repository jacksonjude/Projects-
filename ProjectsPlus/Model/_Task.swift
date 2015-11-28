// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.swift instead.

import CoreData

public enum TaskAttributes: String {
    case completionStatus = "completionStatus"
    case name = "name"
    case syncState = "syncState"
    case uuid = "uuid"
}

public enum TaskRelationships: String {
    case parentProject = "parentProject"
}

@objc public
class _Task: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Task"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Task.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var completionStatus: NSNumber?

    // func validateCompletionStatus(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var name: String?

    // func validateName(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var syncState: NSNumber?

    // func validateSyncState(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    // MARK: - Relationships

    @NSManaged public
    var parentProject: Project?

    // func validateParentProject(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

}

