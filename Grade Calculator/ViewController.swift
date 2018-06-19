//
//  ViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 7/18/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData
/*
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!

    //MARK: Variables
    var classNameArray = [ClassTableView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting tableView Delegate and DataSource
        tableView.dataSource = self
        tableView.dataSource = self
        
        // Load any saved date
        loadTableViewData()
    }

    override func viewWillAppear(animated: Bool) {
        loadTableViewData()
        tableView.reloadData()
    }
    
    //MARK: TableView Functions 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ClassNameTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ClassNameTableViewCell
        let className = classNameArray[indexPath.row]
        cell.classNameLabel.text = className.className
        if (className.overallGrade == 0.01) {
            cell.classOverallGradeLabel.text = "--%"
        }
        else {
            cell.classOverallGradeLabel.text = String(format: "%.2f" ,className.overallGrade) + "%"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            //Delete the item at indexPath
            self.classNameArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            //core data
            self.deleteClass(indexPath.row)
        }
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            // Edit Item
            let selectedClass = self.classNameArray[indexPath.row]
            
            // Custom AlertView
            let editAlertView = SCLAlertView()
            editAlertView.shouldAutoDismiss = false
            let classNameTextField = editAlertView.addTextField("Enter a Class Name")
            classNameTextField.text = selectedClass.className
    
            editAlertView.addButton("Save") {
                
                if (classNameTextField.text! != "")
                {
                    let newClass = ClassTableView(className: classNameTextField.text!, overallGrade: selectedClass.overallGrade)
                    self.classNameArray[indexPath.row] = newClass
                    self.tableView.reloadData()
                    // core data
                    self.editClass(indexPath.row, nameChange: classNameTextField.text!)
                    // Close the view
                    editAlertView.hideView()
                }
            }
            editAlertView.addButton("Cancel") {
                // Close the view
                editAlertView.hideView()
            }
            editAlertView.showCloseButton = false
            
            editAlertView.showTitle("Class Name", subTitle: "Editing Class Name", style: .Edit)
            
            classNameTextField.becomeFirstResponder()

        }
        
        return [delete, edit]
    }
    
    //MARK: Actions
    @IBAction func addButton(sender: UIBarButtonItem) {
        
        // Custom AlertView
        let addAlertView = SCLAlertView()
        //disbale autodismiss
        addAlertView.shouldAutoDismiss = false
        let classNameTextField = addAlertView.addTextField("Enter a Class Name")
        
        addAlertView.addButton("Save") {
            
            if (classNameTextField.text != "")
            {
                let newClass = ClassTableView(className: classNameTextField.text!, overallGrade: 0.01)
                self.classNameArray.append(newClass)
                self.tableView.reloadData()
                //core data
                self.addNewClass(classNameTextField.text!, overallGrade: 0.01)
                // close alert view
                addAlertView.hideView()
            }
        }
        addAlertView.addButton("Cancel") { 
            // Close the view
            addAlertView.hideView()
        }
        addAlertView.showCloseButton = false
        
        addAlertView.showInfo("Class Name", subTitle: "Adding a New Class")
        
        classNameTextField.becomeFirstResponder()
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"
        {
            let newController = segue.destinationViewController as! CategoryViewController
            
            // Get the cell that generated this segue
            if let selectedCell = sender as? ClassNameTableViewCell
            {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedClass = classNameArray[indexPath.row]
                newController.selectedClassName = selectedClass.className
                newController.indexClass = indexPath.row
            }
        }
    }
    
    //MARK: CoreData
    
    // Loading TableViewData
    func loadTableViewData() {
        classNameArray.removeAll()
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let results : [NSManagedObject]? = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            for item in results! {
                let newClass = ClassTableView(className: item.valueForKey("classname") as! String, overallGrade: item.valueForKey("overallGrade") as! Float)
                classNameArray.append(newClass)
            }
        }
        catch
        {
            print ("Error loading data to TableView: \(error)")
        }
    }
    
    // Add new Class to CoreData
    func addNewClass(className: String, overallGrade: Float) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let classEntity = NSEntityDescription.entityForName("Class", inManagedObjectContext: context)
        let newClass = NSManagedObject(entity: classEntity!, insertIntoManagedObjectContext: context)
        
        newClass.setValue(className, forKey: "classname")
        newClass.setValue(overallGrade, forKey: "overallGrade")
        
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving a new class: \(error)")
        }
    }
    
    // Edit an existing class in CoreData
    func editClass(index: Int, nameChange: String) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            var results = try context.executeFetchRequest(request) as! [NSManagedObject]
            let result = results[index]
            result.setValue(nameChange, forKey: "classname")
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error editing class name: \(error)")
            }
        }
        catch
        {
            print("Error editing class name: \(error)")
        }
    }
    
    // Delete an existing class in CoreData
    func deleteClass(index: Int) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            var results = try context.executeFetchRequest(request) as! [NSManagedObject]
            let result = results[index]
            context.deleteObject(result)
            
            do
            {
                try context.save()
            }
            catch
            {
               print("Error deleting class: \(error)")
            }
        }
        catch
        {
            print("Error deleting class: \(error)")
        }
    }
}
*/
