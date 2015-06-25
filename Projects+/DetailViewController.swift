//
//  DetailViewController.swift
//  Projects+
//
//  Created by jackson on 6/24/15.
//  Copyright (c) 2015 jackson. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var projectDescription: UITextView!
    
    var editingDetails: Bool = false {
        didSet {
            self.configureView()
        }
    }
    
    func showDatePicker()
    {
        if let aDueDatePicker = self.dueDatePicker
        {
            aDueDatePicker.enabled = true
            aDueDatePicker.hidden = false
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
            self.detailItem?.setValue(self.projectTitle.text, forKey: "name")
            self.detailItem?.setValue(self.dueDatePicker.date, forKey: "dueDate")
            self.detailItem?.setValue(self.projectDescription.text, forKey: "projectDescription")
            
            var error: NSError? = nil
            if !self.detailItem!.managedObjectContext!.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
        self.editingDetails = !self.editingDetails
    }
    
    var detailItem: NSManagedObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let title = self.projectTitle
            {
                title.text = detail.valueForKey("name") as? String
            }
            if let datePicker = self.dueDatePicker
            {
                let formatter = NSDateFormatter()
                datePicker.date = (detail.valueForKey("dueDate") as? NSDate)!
            }
            if let aProjectDescription = self.projectDescription
            {
                aProjectDescription.text = detail.valueForKey("projectDescription") as? String
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
            
            //disable all fields
            if let title = self.projectTitle
            {
                title.enabled = false
            }
            
            if let dueDate = self.dueDateButton
            {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM-dd-yy HH:mm"
                dueDate.enabled = false
                dueDate.setTitle(formatter.stringFromDate(self.dueDatePicker.date), forState: UIControlState.Normal)
            }
            
            if let projectDescriptionField = self.projectDescription
            {
                projectDescriptionField.editable = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if let aDueDatePicker = self.dueDatePicker
        {
            aDueDatePicker.hidden = true
            aDueDatePicker.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

