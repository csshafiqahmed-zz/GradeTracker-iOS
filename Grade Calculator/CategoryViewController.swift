//
//  CategoryViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 8/14/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var categoryArray = [CategoryTableView]()
    
    // seque variables
    var indexClass : Int?
    var selectedClassName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set the Navigation Bar title
        navigationItem.title = selectedClassName
        
        // tableView Delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableView header seperator
        let px = 1 / UIScreen.mainScreen().scale
        let frame = CGRectMake(0, 0, self.tableView.frame.size.width, px)
        let line : UIView = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
        //categoryPrecentage()
        
        // Load core data
        loadTableViewData()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        categoryPrecentage()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadTableViewData()
        tableView.reloadData()
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
        return categoryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell
        let category = categoryArray[indexPath.row]
        cell.categoryName.text = category.categoryName
        cell.categoryWeight.text = String(category.categoryWeight) + "%"
        if (category.categoryAverage == 0.01) {
            cell.categoryAverage.text = "--%"
        }
        else
        {
            cell.categoryAverage.text = String(format: "%.2f" ,category.categoryAverage) + "%"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            //Delete the item at indexPath
            self.categoryArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            self.categoryPrecentage()
            //core data
            self.deleteCategory(self.indexClass!, indexCategory: indexPath.row)
        }
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            // Edit Item
            let selectedCategory = self.categoryArray[indexPath.row]
            
            // Custom AlertView
            let editAlertView = SCLAlertView()
            editAlertView.shouldAutoDismiss = false
            let categoryNameTextField = editAlertView.addTextField("Enter Category Name")
            let cateogryWeightTextField = editAlertView.addTextField("Enter Category Weight")
            cateogryWeightTextField.keyboardType = UIKeyboardType.DecimalPad
            
            categoryNameTextField.text = selectedCategory.categoryName
            cateogryWeightTextField.text = String(selectedCategory.categoryWeight)
            
            editAlertView.addButton("Save") {
                
                // convert text to float
                let num1 = Float(cateogryWeightTextField.text!)
                
                if ((categoryNameTextField.text! != "") && (num1 != nil))
                {
                    let newCategory = CategoryTableView(categoryName: categoryNameTextField.text!, categoryWeight: Float(cateogryWeightTextField.text!)!, categoryAverage: selectedCategory.categoryAverage)
                    self.categoryArray[indexPath.row] = newCategory
                    self.tableView.reloadData()
                    //Core Data
                    self.editCategory(self.indexClass!, indexCategory: indexPath.row, newName: categoryNameTextField.text!, newWeight: Float(cateogryWeightTextField.text!)!)
                    self.categoryPrecentage()
                    // Close the view
                    editAlertView.hideView()
                }
            }
            editAlertView.addButton("Cancel") {
                // Close the view
                editAlertView.hideView()
            }
            editAlertView.showCloseButton = false

            
            editAlertView.showTitle("Category", subTitle: "Editing a Category", style: .Edit)
            
            categoryNameTextField.becomeFirstResponder()
            
        }
        
        return [delete, edit]
    }

    
    // MARK: Actions
    
    @IBAction func addButton(sender: UIBarButtonItem) {
        
        // Custom AlertView
        let addAlertView = SCLAlertView()
        addAlertView.shouldAutoDismiss = false
        let categoryNameTextField = addAlertView.addTextField("Enter Category Name")
        let cateogryWeightTextField = addAlertView.addTextField("Enter Category Weight")
        
        cateogryWeightTextField.keyboardType = UIKeyboardType.DecimalPad
        
        
        addAlertView.addButton("Save") {
            
            // convert text to float
            let num1 = Float(cateogryWeightTextField.text!)
            
            if ((categoryNameTextField.text! != "") && (num1 != nil))
            {
                let newCategory = CategoryTableView(categoryName: categoryNameTextField.text!, categoryWeight: Float(cateogryWeightTextField.text!)!, categoryAverage: 0.01)
                self.categoryArray.append(newCategory)
                self.tableView.reloadData()
                // Core Data
                self.addNewCategory(categoryNameTextField.text!, categoryWeight: Float(cateogryWeightTextField.text!)!, categoryAverage: 0.01)
                self.categoryPrecentage()
                // Close the view
                addAlertView.hideView()
            }
        }
        addAlertView.addButton("Cancel") { 
            // Close the view
            addAlertView.hideView()
        }
        addAlertView.showCloseButton = false
        
        addAlertView.showInfo("Category", subTitle: "Adding a New Category")
        
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"
        {

            let newController = segue.destinationViewController as! GradeViewController
            
            // Get the cell that generated this segue
            if let selectedCell = sender as? CategoryTableViewCell
            {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                newController.indexClass = indexClass!
                newController.indexCategory = indexPath.row
                newController.categoryName = selectedCell.categoryName.text
            }
        }
    }
    
    // MARK: COREDATA Functions
    
    //Loading tableView Data
    func loadTableViewData() {
        
        // Empty the array
        categoryArray.removeAll()
        
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
                
                for categoryResult in categoryResults
                {
                    let categoryName = categoryResult.valueForKey("categoryName") as! String
                    let categoryWeight = categoryResult.valueForKey("categoryWeight") as! Float
                    let categoryAverage = categoryResult.valueForKey("categoryAverage") as! Float
                    
                    let newCategory = CategoryTableView(categoryName: categoryName, categoryWeight: categoryWeight, categoryAverage: categoryAverage)
                    categoryArray.append(newCategory)
                }
            }
            print("done")
        }
        catch
        {
            print("Error loading data to tableView: \(error)")
        }
    }
    
    //Add new category 
    func addNewCategory(categoryName : String, categoryWeight : Float, categoryAverage: Float) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass!]
                let categoryResults = classResult.mutableOrderedSetValueForKeyPath("category")
                
                
                let newCategory = NSManagedObject(entity: categoryEntity!, insertIntoManagedObjectContext: context)
                newCategory.setValue(categoryName, forKey: "categoryName")
                newCategory.setValue(categoryWeight, forKey: "categoryWeight")
                newCategory.setValue(categoryAverage, forKey: "categoryAverage")
                
                categoryResults.addObject(newCategory)
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
    func editCategory(indexClass: Int, indexCategory: Int, newName: String, newWeight: Float) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass]
                let categoryResults = classResult.valueForKey("category") as? NSMutableOrderedSet
                let category = categoryResults![indexCategory]
                category.setValue(newName, forKey: "categoryName")
                category.setValue(newWeight, forKey: "categoryWeight")
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
    func deleteCategory(indexClass: Int, indexCategory: Int) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Class")
        
        do
        {
            let classResults = try context.executeFetchRequest(request) as? [NSManagedObject]
            
            if classResults?.count != 0
            {
                let classResult = classResults![indexClass]
                let categoryResults = classResult.valueForKey("category") as? NSMutableOrderedSet
                let category = categoryResults![indexCategory]
                context.deleteObject(category as! NSManagedObject)
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
    
    // Calculate Average
    func categoryPrecentage() {
        // Array count
        var arrayCount = 0
        // Total percentage of the grades
        var totalPercent = Float()
        var maxPercent = Float()
        // iterate thorugh a for loop to add up all of the percentages for each grade
        for category in categoryArray
        {
            if (category.categoryAverage != 0.01)
            {
                totalPercent += category.categoryAverage * category.categoryWeight
                maxPercent += category.categoryWeight
                arrayCount += 1
            }
        }
        // calcuate the average
        let average = totalPercent/maxPercent
        
        if (arrayCount > 0)
        {
            // Add it to core data
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDel.managedObjectContext
            
            let request = NSFetchRequest(entityName: "Class")
            
            do
            {
                var results = try context.executeFetchRequest(request) as! [NSManagedObject]
                let result = results[indexClass!]
                result.setValue(average, forKey: "overallGrade")
                
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
    }
}
