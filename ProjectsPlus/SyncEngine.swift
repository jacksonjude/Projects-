//
//  SyncEngine.swift
//  ProjectsPlus
//
//  Created by jackson on 8/21/15.
//  Copyright (c) 2015 jackson. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class SyncEngine: NSObject, NSFetchedResultsControllerDelegate
{
    let kIsSynced = 1
    let kNeedsSync = 0
    
    var justCompletedSync = false
        
    var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.parentContext = AppDelegate.sharedAppDelegate().managedObjectContext
        //managedObjectContext.parentContext = AppDelegate.sharedAppDelegate().masterController?.managedObjectContext!
        return managedObjectContext
    }()
    
    var fetchedResultsController: NSFetchedResultsController?
    
    @objc func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        
        let resultsProject = anObject as! Project
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        
        if self.justCompletedSync == true
        {
            self.justCompletedSync = false
        }
        else
        {
            switch type
            {
                case .Insert:
                    break
                case .Delete:
                    /*CKRecordZoneID(zoneName: "Project" ,ownerName: CKOwnerDefaultName)*/
                    let query = CKQuery(recordType: "Projects", predicate: NSPredicate(format: "uuid == %@", resultsProject.uuid!))
                    privateDatabase.performQuery(query, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID, completionHandler:
                    { (results, error) -> Void in
                        if error != nil
                        {
                            NSLog("Error:%@", error!)
                        }
                        else
                        {
                            if results!.first != nil
                            {
                                privateDatabase.deleteRecordWithID(CKRecordID(recordName: resultsProject.uuid!), completionHandler: { (recordID, newError) -> Void in
                                    if newError != nil
                                    {
                                        var newError: NSError? = nil
                                        
                                        resultsProject.syncState = self.kIsSynced
                                        
                                        self.justCompletedSync = true
                                        
                                        do {
                                            try self.managedObjectContext.save()
                                        } catch let error as NSError {
                                            newError = error
                                            NSLog("%@", newError!)
                                        } catch {
                                            fatalError()
                                        }
                                    }
                                })
                            }
                        }
                    })
                case .Update:
                    self.justSaved(resultsProject)
                case .Move:
                    self.justSaved(resultsProject)
            }
        }
    }
    
    func justSaved(resultsProject: Project)
    {
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        let query = CKQuery(recordType: "Projects", predicate: NSPredicate(format: "uuid == %@", resultsProject.uuid!))
        privateDatabase.performQuery(query, inZoneWithID: CKRecordZone.defaultRecordZone().zoneID, completionHandler:
            { (results, error) -> Void in
                if error != nil
                {
                    NSLog("Error:%@", error!)
                }
                else
                {
                    if results?.count > 0
                    {
                        //let noteID = CKRecordID(recordName: resultsProject.uuid!)
                        //let noteRecord = CKRecord(recordType: "Projects", recordID: noteID)
                        let noteRecord = (results?.first)! as CKRecord
                        noteRecord.setObject(resultsProject.name, forKey: "name")
                        noteRecord.setObject(resultsProject.dueDate, forKey: "dueDate")
                        noteRecord.setObject(resultsProject.projectDescription, forKey: "projectDescription")
                        noteRecord.setObject(resultsProject.uuid, forKey: "uuid")
                        privateDatabase.saveRecord(noteRecord, completionHandler: { (record, error) -> Void in
                            if (error != nil) {
                                NSLog("Error: \(error)")
                            }
                            else
                            {
                                self.managedObjectContext.performBlock
                                    {
                                        var newError: NSError? = nil
                                        
                                        resultsProject.syncState = self.kIsSynced
                                        
                                        self.justCompletedSync = true
                                        
                                        do {
                                            try self.managedObjectContext.save()
                                        } catch let error as NSError {
                                            newError = error
                                            NSLog("%@", newError!)
                                        } catch {
                                            fatalError()
                                        }
                                }
                            }
                        })
                    }
                    else
                    {
                        let fetchRequest = NSFetchRequest(entityName: "Project")
                        
                        // Create a sort descriptor object that sorts on the "title"
                        // property of the Core Data object
                        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
                        
                        // Set the list of sort descriptors in the fetch request,
                        // so it includes the sort descriptor
                        fetchRequest.sortDescriptors = [sortDescriptor]
                        
                        // Create a new predicate that filters out any object that
                        // doesn't have a title of "Best Language" exactly.
                        let predicate = NSPredicate(format: "syncState == %i", self.kNeedsSync)
                        
                        // Set the predicate on the fetch request
                        fetchRequest.predicate = predicate
                        
                        let fetchResults: [AnyObject]?
                        var error: NSError? = nil
                        
                        do {
                            fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as? [Project]
                        } catch let error1 as NSError {
                            error = error1
                            fetchResults = nil
                        } catch {
                            fatalError()
                        }
                        if error != nil
                        {
                            NSLog("An Error Occored:", error!)
                        }
                        else
                        {
                            NSLog("Fetched Objects To Update From CoreData...")
                        }
                        let projects = fetchResults
                        for resultsProject in projects! as! [Project]
                        {
                            ///////
                            
                            if resultsProject.syncState == self.kNeedsSync
                            {
                                
                                let noteID = CKRecordID(recordName: resultsProject.uuid!)
                                
                                let noteRecord = CKRecord(recordType: "Projects", recordID: noteID)
                                noteRecord.setObject(resultsProject.name, forKey: "name")
                                noteRecord.setObject(resultsProject.dueDate, forKey: "dueDate")
                                noteRecord.setObject(resultsProject.projectDescription, forKey: "projectDescription")
                                noteRecord.setObject(resultsProject.uuid, forKey: "uuid")
                                
                                let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
                                
                                privateDatabase.saveRecord(noteRecord, completionHandler: { (record, error) -> Void in
                                    if (error != nil) {
                                        NSLog("Error: \(error)")
                                    }
                                    else
                                    {
                                        self.managedObjectContext.performBlock
                                            {
                                                var newError: NSError? = nil
                                                
                                                resultsProject.syncState = self.kIsSynced
                                                
                                                self.justCompletedSync = true
                                                
                                                do {
                                                    try self.managedObjectContext.save()
                                                } catch let error as NSError {
                                                    newError = error
                                                    NSLog("%@", newError!)
                                                } catch {
                                                    fatalError()
                                                }
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
        })
    }
    
    override init()
    {
        super.init()
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Project", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        self.fetchedResultsController!.delegate = self
        
        self.managedObjectContext.performBlockAndWait
        {
            var error: NSError? = nil
            do {
                try self.fetchedResultsController!.performFetch()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(error), \(error!.userInfo)")
            } catch {
                fatalError()
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { (notification) -> Void in
            let sender = notification.object as! NSManagedObjectContext
            if sender !== self.managedObjectContext
            {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
    
    /*func contextDidSave(notification: NSNotification)
    {
        let sender = notification.object as! NSManagedObjectContext
        if sender !== self.managedObjectContext
        {
            self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }*/
}