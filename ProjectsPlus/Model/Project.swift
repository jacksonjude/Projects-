import Foundation
import CloudKit

@objc(Project)

public class Project: _Project, Syncable {

	// Custom logic goes here.
    
    override public func willSave()
    {
        super.willSave()
        
        if self.createdAt == nil
        {
            self.setPrimitiveValue(NSDate(), forKey: "createdAt")
        }
        
        self.setPrimitiveValue(NSDate(), forKey: "updatedAt")
        
    }

    func updateFromRemote(remoteRecord: CKRecord)
    {
        self.name = remoteRecord.objectForKey("name") as? String
        self.dueDate = remoteRecord.objectForKey("dueDate") as? NSDate
        self.projectDescription = remoteRecord.objectForKey("projectDescription") as? String
        self.uuid = remoteRecord.objectForKey("uuid") as? String
    }
    
    func updateToRemote(remoteRecord: CKRecord)
    {
        remoteRecord.setObject(self.name, forKey: "name")
        remoteRecord.setObject(self.dueDate, forKey: "dueDate")
        remoteRecord.setObject(self.projectDescription, forKey: "projectDescription")
        remoteRecord.setObject(self.uuid, forKey: "uuid")
    }

}
