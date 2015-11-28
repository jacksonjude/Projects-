import Foundation
import CloudKit

@objc(Task)

public class Task: _Task, Syncable {

	// Custom logic goes here.
    
    
    func updateFromRemote(remoteRecord: CKRecord)
    {
        
    }
    
    func updateToRemote(remoteReacord: CKRecord)
    {
        
    }
}
