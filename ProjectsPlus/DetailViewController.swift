//
//  DetailViewController.swift
//  Projects+
//
//  Created by jackson on 6/24/15.
//  Copyright (c) 2015 jackson. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var projectDescription: UITextView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var tasksTableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Task

        cell.textLabel?.font = UIFont(name: "SanFrancisco", size: 1)
        
        cell.textLabel!.text = NSString(format: "%@", object.name!) as String
    }
    
    var editingDetails: Bool = false
    {
        didSet
        {
            self.configureView()
        }
    }
    
    func showDatePicker()
    {
        if let aDueDatePicker = self.dueDatePicker
        {
            aDueDatePicker.enabled = true
            aDueDatePicker.hidden = false
            
            self.view.endEditing(true)
        }
    }
    
    func toggleEditingDetails()
    {
        if self.editingDetails
        {
            if let aDueDatePicker = self.dueDatePicker
            {
                aDueDatePicker.hidden = true
                aDueDatePicker.enabled = false
            }
            
            //save
            self.detailItem?.name = self.projectTitle.text
            self.detailItem?.dueDate = self.dueDatePicker.date
            self.detailItem?.projectDescription = self.projectDescription.text
            
            var error: NSError? = nil
            do {
                try self.detailItem!.managedObjectContext!.save()
            } catch let error1 as NSError {
                error = error1
                NSLog("%@", error!)
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            self.navigationItem.leftBarButtonItem?.enabled = true
        }
        else
        {
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
        self.editingDetails = !self.editingDetails
    }
    
    var detailItem: Project? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func addTask()
    {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Name",
            message: "Enter a name for the task",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Name"
        })
        
        let action = UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:
            {
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields
                {
                    let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.fetchedResultsController.managedObjectContext)
                    let context = self.fetchedResultsController.managedObjectContext
                    let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Task
                    
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    newManagedObject.name = enteredText
                    
                    newManagedObject.parentProject = self.detailItem!
                    newManagedObject.uuid = NSUUID().UUIDString
                    
                    //self.detailItem?.mutableSetValueForKey(key: String).addObject(object: AnyObject)
                    
                    var error: NSError? = nil
                    do {
                        try context.save()
                    } catch let error1 as NSError {
                        error = error1
                        NSLog("%@", error!)
                        abort()
                    }
                }
            })
        
        alertController?.addAction(action)
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tasksTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tasksTableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tasksTableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tasksTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tasksTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            AppDelegate.sharedAppDelegate().syncEngine?.controller(controller, didChangeObject: anObject, atIndexPath: indexPath, forChangeType: type, newIndexPath: newIndexPath)
        case .Update:
            self.configureCell(tasksTableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tasksTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tasksTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tasksTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! Task)
            
            var error: NSError? = nil
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                NSLog("%@", error!)
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.detailItem!.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "parentProject == %@", self.detailItem!)
        
        fetchRequest.predicate = predicate
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.detailItem!.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        do {
            try _fetchedResultsController!.performFetch()
        } catch let error1 as NSError {
            error = error1
            NSLog("%@", error!)
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func configureView()
    {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem
        {
            if let title = self.projectTitle
            {
                title.text = detail.name
            }
            if let datePicker = self.dueDatePicker
            {
                datePicker.date = detail.dueDate!!
            }
            if let aProjectDescription = self.projectDescription
            {
                aProjectDescription.text = detail.projectDescription
            }
            if let addTaskButton = self.addTaskButton
            {
                addTaskButton.addTarget(self, action: "addTask", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        if editingDetails
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Done", style:UIBarButtonItemStyle.Plain, target:self, action:"toggleEditingDetails")
            
            //enable all fields
            
            if let title = self.projectTitle
            {
                title.enabled = true
            }
            if let aDueDateButton = self.dueDateButton
            {
                aDueDateButton.enabled = true
                aDueDateButton.addTarget(self, action: "showDatePicker", forControlEvents: UIControlEvents.TouchUpInside)
            }
            if let projectDescriptionField = self.projectDescription
            {
                projectDescriptionField.editable = true
            }
        }
        else
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "toggleEditingDetails")
            
            //disable all field
            
            if let title = self.projectTitle
            {
                title.enabled = false
            }
            
            if let dueDate = self.dueDateButton
            {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM-dd-yy hh:mm"
                dueDate.enabled = false
                dueDate.setTitle(formatter.stringFromDate(self.dueDatePicker.date), forState: UIControlState.Normal)
            }
            
            if let projectDescriptionField = self.projectDescription
            {
                projectDescriptionField.editable = false
            }
        }
        
        self.changeFonts()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"changeFonts", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if let aDueDatePicker = self.dueDatePicker
        {
            aDueDatePicker.hidden = true
            aDueDatePicker.enabled = false
        }
        
        self.tasksTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TaskCell")
    }
    
    func changeFonts()
    {
        if let title = self.projectTitle
        {
            title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        }
        if let aProjectDescription = self.projectDescription
        {
            aProjectDescription.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        if let dueDate = self.dueDateButton
        {
            dueDate.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}