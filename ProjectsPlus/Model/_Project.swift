// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.swift instead.

import CoreData

public enum ProjectAttributes: String {
    case createdAt = "createdAt"
    case dueDate = "dueDate"
    case name = "name"
    case projectDescription = "projectDescription"
    case syncState = "syncState"
    case updatedAt = "updatedAt"
    case uuid = "uuid"
}

public enum ProjectRelationships: String {
    case tasks = "tasks"
}

@objc public
class _Project: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Project"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Project.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var createdAt: NSDate?

    // func validateCreatedAt(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var dueDate: NSDate?

    // func validateDueDate(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var name: String?

    // func validateName(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var projectDescription: String?

    // func validateProjectDescription(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var syncState: NSNumber?

    // func validateSyncState(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var updatedAt: NSDate?

    // func validateUpdatedAt(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var uuid: String?

    // func validateUuid(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    // MARK: - Relationships

    @NSManaged public
    var tasks: NSSet

}

extension _Project {

    func addTasks(objects: NSSet) {
        let mutable = self.tasks.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.tasks = mutable.copy() as! NSSet
    }

    func removeTasks(objects: NSSet) {
        let mutable = self.tasks.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.tasks = mutable.copy() as! NSSet
    }

    func addTasksObject(value: Task!) {
        let mutable = self.tasks.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.tasks = mutable.copy() as! NSSet
    }

    func removeTasksObject(value: Task!) {
        let mutable = self.tasks.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.tasks = mutable.copy() as! NSSet
    }

}

