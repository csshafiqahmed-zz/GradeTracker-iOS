//
//  ClassViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/18/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import Realm

class ClassViewController: UIViewController {
    
    /**
     *  UI Elements
     */
    private var addButton: UIBarButtonItem!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        self.navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.title = "Classes"
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        view.addSubview(tableView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
    }
    
    @objc private func addButtonAction() {
        // Custom AlertView
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false, shouldAutoDismiss: false
        )
        let addAlertView = SCLAlertView(appearance: appearance)
        let classNameTextField = addAlertView.addTextField("Enter a Class Name")
        
        addAlertView.addButton("Save") {
            // TODO: Add functionality for saving new class info
//            if (classNameTextField.text != "")
//            {
//                let newClass = ClassTableView(className: classNameTextField.text!, overallGrade: 0.01)
//                self.classNameArray.append(newClass)
//                self.tableView.reloadData()
//                //core data
//                self.addNewClass(classNameTextField.text!, overallGrade: 0.01)
//                // close alert view
//                addAlertView.hideView()
//            }
            addAlertView.hideView()
        }
        addAlertView.addButton("Cancel") {
            addAlertView.hideView()
        }
        addAlertView.showInfo("Class Name", subTitle: "Adding a New Class")
        
        classNameTextField.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClassViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ClassTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.classNameLabel.text = "Test"
        cell.classOverallGradeLabel.text = "--%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // TODO: Delete functionality
            //            //Delete the item at indexPath
            //            self.classNameArray.removeAtIndex(indexPath.row)
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            //            //core data
            //            self.deleteClass(indexPath.row)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // TODO: Edit functionality
            // Edit Item
//            let selectedClass = self.classNameArray[indexPath.row]
            
            // Custom AlertView
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false, shouldAutoDismiss: false
            )
            let editAlertView = SCLAlertView(appearance: appearance)
            let classNameTextField = editAlertView.addTextField("Enter a Class Name")
//            classNameTextField.text = selectedClass.className
//
            editAlertView.addButton("Save") {
//
//                if (classNameTextField.text! != "")
//                {
//                    let newClass = ClassTableView(className: classNameTextField.text!, overallGrade: selectedClass.overallGrade)
//                    self.classNameArray[indexPath.row] = newClass
//                    self.tableView.reloadData()
//                    // core data
//                    self.editClass(indexPath.row, nameChange: classNameTextField.text!)
//                    // Close the view
                    editAlertView.hideView()
//                }
            }
            editAlertView.addButton("Cancel") {
                editAlertView.hideView()
            }
            editAlertView.showTitle("Class Name", subTitle: "Editing Class Name", style: .edit)
            classNameTextField.becomeFirstResponder()
            
        }
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}
