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
        }
        self.editingDetails = !self.editingDetails
    }
    
    var detailItem: Project? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

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