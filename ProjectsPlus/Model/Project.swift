import Foundation

@objc(Project)

class Project: _Project {

	// Custom logic goes here.
    
    override func willSave()
    {
        super.willSave()
        
        if self.createdAt == nil
        {
            self.setPrimitiveValue(NSDate(), forKey: "createdAt")
        }
        
        self.setPrimitiveValue(NSDate(), forKey: "updatedAt")
        
    }

}
