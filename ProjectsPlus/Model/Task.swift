import Foundation
import CloudKit
import CoreData

@objc(Task)

public class Task: _Task, Syncable {

	// Custom logic goes here.
    let kIsSynced = 1
    let kNeedsSync = 0
    
    func updateFromRemote(remoteRecord: CKRecord)
    {
        self.completionStatus = remoteRecord.objectForKey("completionStatus") as? NSNumber
        self.name = remoteRecord.objectForKey("name") as? String
        self.syncState = remoteRecord.objectForKey("syncState") as? NSNumber
        self.uuid = remoteRecord.objectForKey("uuid") as? String
        let parentUUID = remoteRecord.objectForKey("linkedProjectUUID") as? String
        
        let project = AppDelegate.sharedAppDelegate().syncEngine?.fetchObjects("Project", sortDescriptorInput: "dueDate", predicate: NSPredicate(format: "uuid == %@", parentUUID!)).first as? Project
        self.parentProject = project
    }
    
    func updateToRemote(remoteRecord: CKRecord)
    {
        remoteRecord.setObject(self.completionStatus, forKey: "completionStatus")
        remoteRecord.setObject(self.name, forKey: "name")
        remoteRecord.setObject(self.syncState, forKey: "syncState")
        remoteRecord.setObject(self.uuid, forKey: "uuid")
        remoteRecord.setObject(self.parentProject?.uuid, forKey: "linkedProjectUUID")
    }
}
