import Foundation

@objc(Project)

public class Project: _Project {

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

}
