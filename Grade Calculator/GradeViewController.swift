//
//  GradeViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 8/19/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class GradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: Variables
    var gradeArray = [GradeTableView]()
    var indexClass : Int?
    var indexCategory : Int?
    var categoryName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //tableView Delegate and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.hidesBackButton = false
        self.navigationItem.title = categoryName
        
        //let newGrade = GradeTableView(gradeName: "ex1", gradeScore: 24, gradeMaxScore: 35, gradePercent: (24/35)*100)
        //
        //self.gradeArray.append(newGrade)
        
        // load core data
        loadTableViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "GradeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GradeTableViewCell
        let grade = gradeArray[indexPath.row]
        let scoreString = String(grade.gradeScore) + "/" + String(grade.gradeMaxScore)
        
        cell.gradeName.text = grade.gradeName
        cell.gradeScore.text = String(format: "%.2f" ,grade.gradePercent) + " %"
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            //Delete the item at indexPath
            self.gradeArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            //core data
            self.deleteGrade(indexPath.row)
            self.categoryPrecentage()
        }
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            // Edit Item
            let selectedGrade = self.gradeArray[indexPath.row]
            
            // Custom AlertView
            let editAlertView = SCLAlertView()
            editAlertView.shouldAutoDismiss = false
            let gradeNameTextField = editAlertView.addTextField("Enter Assignment Name")
            let gradeScoreTextField = editAlertView.addTextField("Enter your score")
            let gradeMaxScoreTextField = editAlertView.addTextField("Enter max possible score")
            gradeScoreTextField.keyboardType = UIKeyboardType.DecimalPad
            gradeMaxScoreTextField.keyboardType = UIKeyboardType.DecimalPad
            
            gradeNameTextField.text = selectedGrade.gradeName
            gradeScoreTextField.text = String(selectedGrade.gradeScore)
            gradeMaxScoreTextField.text = String(selectedGrade.gradeMaxScore)
            
            editAlertView.addButton("Save") {
                
                // Check if gradeScoreTextField and gradeMaxScoreTextField are numbers or not
                let num1 = Float(gradeScoreTextField.text!)
                let num2 = Float(gradeMaxScoreTextField.text!)
                
                if ((num1 != nil) && (num2 != nil) && (gradeNameTextField.text! != ""))
                {
                    // grade percent
                    let percent = (Float(gradeScoreTextField.text!)! / Float(gradeMaxScoreTextField.text!)!) * 100
                    
                    let newGrade = GradeTableView(gradeName: gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
                    self.gradeArray[indexPath.row] = newGrade
                    self.tableView.reloadData()
                    self.editGrade(indexPath.row, gradeName: gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
                    self.categoryPrecentage()
                    // Close the View
                    editAlertView.hideView()
                }
            }
            editAlertView.addButton("Cancel") {
                // Close the view
                editAlertView.hideView()
            }
            editAlertView.showCloseButton = false
            
            
            editAlertView.showTitle("Assignment", subTitle: "Editing a Assignment", style: .Edit)
            
            gradeNameTextField.becomeFirstResponder()
            
        }
        
        return [delete, edit]
    }
    

    
    // MARK: Actions
    @IBAction func addButton(sender: UIBarButtonItem) {
        // Disable Add Button
        //addButton.enabled = false
        
        // Custom AlertView
        let addAlertView = SCLAlertView()
        addAlertView.shouldAutoDismiss = false
        addAlertView.showCloseButton = false
        let gradeNameTextField = addAlertView.addTextField("Enter Assignment Name")
        let gradeScoreTextField = addAlertView.addTextField("Enter your score")
        let gradeMaxScoreTextField = addAlertView.addTextField("Enter max possible score")
        gradeScoreTextField.keyboardType = UIKeyboardType.DecimalPad
        gradeMaxScoreTextField.keyboardType = UIKeyboardType.DecimalPad
        
        
        addAlertView.addButton("Save") {
            
            // Check if gradeScoreTextField and gradeMaxScoreTextField are numbers or not
            let num1 = Float(gradeScoreTextField.text!)
            let num2 = Float(gradeMaxScoreTextField.text!)
            
            if ((num1 != nil) && (num2 != nil) && (gradeNameTextField.text! != ""))
            {
                // grade percent
                 let percent = (Float(gradeScoreTextField.text!)! / Float(gradeMaxScoreTextField.text!)!) * 100
                 
                 let newGrade = GradeTableView(gradeName: gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
                 self.gradeArray.append(newGrade)
                 self.tableView.reloadData()
                 self.addNewGrade(gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
                 self.categoryPrecentage()
                // Close the View
                addAlertView.hideView()
            }
        }
        addAlertView.addButton("Cancel") {
            // Close the view
            addAlertView.hideView()
        }
        
        addAlertView.showInfo("Assignment", subTitle: "Adding a New Assignment")

    }
    
    // MARK: Calculations
    func categoryPrecentage() {
        // Array count
        let arrayCount = gradeArray.count
        // Total percentage of the grades
        var totalPercent = Float()
        // iterate thorugh a for loop to add up all of the percentages for each grade
        for grade in gradeArray
        {
            totalPercent += grade.gradePercent
        }
        // calcuate the average 
        let average = totalPercent/Float(arrayCount)
        
        // Save it into Core Data
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass!]
                let categoryResults = classResult.valueForKey("category") as? NSMutableOrderedSet
                let category = categoryResults![indexCategory!]
                category.setValue(average, forKey: "categoryAverage")
            }
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving category average: \(error)")
            }
        }
        catch
        {
            print("Error saving category average: \(error)")
        }
    }

    
    // MARK: Core Data
    
    //Loading tableView Data
    func loadTableViewData() {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass!]
                let categoryResults = classResult.valueForKey("category") as! NSMutableOrderedSet
                let categoryResult = categoryResults[indexCategory!]
                let gradeResults = categoryResult.valueForKey("grade") as! NSMutableOrderedSet

                if gradeResults.count != 0
                {
                    for gradeResult in gradeResults
                    {
                        let gradeName = gradeResult.valueForKey("gradeName") as! String
                        let gradeScore = gradeResult.valueForKey("gradeScore") as! Float
                        let gradeMaxScore = gradeResult.valueForKey("gradeMaxScore") as! Float
                        let gradePercent = gradeResult.valueForKey("gradePercent") as! Float
                        
                        let newGrade = GradeTableView(gradeName: gradeName, gradeScore: gradeScore, gradeMaxScore: gradeMaxScore, gradePercent: gradePercent)
                        gradeArray.append(newGrade)
                    }

                }
            }
        }
        catch
        {
            print("Error loading data to tableView: \(error)")
        }
    }
    
    //Add new category
    func addNewGrade(gradeName: String, gradeScore : Float, gradeMaxScore: Float, gradePercent: Float) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        let gradeEntity = NSEntityDescription.entityForName("Grade", inManagedObjectContext: context)
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass!]
                let categoryResults = classResult.mutableOrderedSetValueForKeyPath("category")
                let categoryResult = categoryResults[indexCategory!]
                let gradeResults = categoryResult.mutableOrderedSetValueForKeyPath("grade")
                
                let newGrade = NSManagedObject(entity: gradeEntity!, insertIntoManagedObjectContext: context)
                newGrade.setValue(gradeName, forKey: "gradeName")
                newGrade.setValue(gradeScore, forKey: "gradeScore")
                newGrade.setValue(gradeMaxScore, forKey: "gradeMaxScore")
                newGrade.setValue(gradePercent, forKey: "gradePercent")
                
                gradeResults.addObject(newGrade)
            }
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving new category: \(error)")
            }
        }
        catch
        {
            print("Error saving new category: \(error)")
        }
    }
    
    // Edit category
    func editGrade(indexGrade: Int, gradeName: String, gradeScore : Float, gradeMaxScore: Float, gradePercent: Float) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass!]
                let categoryResults = classResult.valueForKey("category") as? NSMutableOrderedSet
                let categoryResult = categoryResults!.objectAtIndex(indexCategory!) as! NSManagedObject
                let gradeResults = categoryResult.valueForKey("grade") as? NSMutableOrderedSet
                let gradeResult = gradeResults!.objectAtIndex(indexGrade) as! NSManagedObject
                
                gradeResult.setValue(gradeName, forKey: "gradeName")
                gradeResult.setValue(gradeScore, forKey: "gradeScore")
                gradeResult.setValue(gradeMaxScore, forKey: "gradeMaxScore")
                gradeResult.setValue(gradePercent, forKey: "gradePercent")
            }
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving new category: \(error)")
            }
        }
        catch
        {
            print("Error saving new category: \(error)")
        }
        
    }
    
    // Delete Category
    func deleteGrade(indexGrade: Int) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass!]
                let categoryResults = classResult.valueForKey("category") as? NSMutableOrderedSet
                let categoryResult = categoryResults!.objectAtIndex(indexCategory!) as! NSManagedObject
                let gradeResults = categoryResult.valueForKey("grade") as? NSMutableOrderedSet
                let gradeResult = gradeResults!.objectAtIndex(indexGrade) as! NSManagedObject
                context.deleteObject(gradeResult)
            }
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error deleting a category: \(error)")
            }
        }
        catch
        {
            print("Error deleting a category: \(error)")
        }
        
    }

}
