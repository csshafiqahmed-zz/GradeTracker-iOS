//
//  GradeViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/19/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import Realm

class GradeViewController: UIViewController {
    
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
        let gradeNameTextField = addAlertView.addTextField("Enter Assignment Name")
        let gradeScoreTextField = addAlertView.addTextField("Enter your score")
        let gradeMaxScoreTextField = addAlertView.addTextField("Enter max possible score")
        gradeScoreTextField.keyboardType = UIKeyboardType.decimalPad
        gradeMaxScoreTextField.keyboardType = UIKeyboardType.decimalPad
        
        
        addAlertView.addButton("Save") {
            
            // Check if gradeScoreTextField and gradeMaxScoreTextField are numbers or not
//            let num1 = Float(gradeScoreTextField.text!)
//            let num2 = Float(gradeMaxScoreTextField.text!)
//
//            if ((num1 != nil) && (num2 != nil) && (gradeNameTextField.text! != ""))
//            {
//                // grade percent
//                let percent = (Float(gradeScoreTextField.text!)! / Float(gradeMaxScoreTextField.text!)!) * 100
//
//                let newGrade = GradeTableView(gradeName: gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
//                self.gradeArray.append(newGrade)
//                self.tableView.reloadData()
//                self.addNewGrade(gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
//                self.categoryPrecentage()
//                // Close the View
                addAlertView.hideView()
//            }
        }
        addAlertView.addButton("Cancel") {
            addAlertView.hideView()
        }
        addAlertView.showInfo("Assignment", subTitle: "Adding a New Assignment")
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

extension GradeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GradeTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.gradeNameLabel.text = "Test"
        cell.gradeScoreLabel.text = "--%"
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
            let gradeNameTextField = editAlertView.addTextField("Enter Assignment Name")
            let gradeScoreTextField = editAlertView.addTextField("Enter your score")
            let gradeMaxScoreTextField = editAlertView.addTextField("Enter max possible score")
            gradeScoreTextField.keyboardType = UIKeyboardType.decimalPad
            gradeMaxScoreTextField.keyboardType = UIKeyboardType.decimalPad
            
//            gradeNameTextField.text = selectedGrade.gradeName
//            gradeScoreTextField.text = String(selectedGrade.gradeScore)
//            gradeMaxScoreTextField.text = String(selectedGrade.gradeMaxScore)
            
            editAlertView.addButton("Save") {
                
                // Check if gradeScoreTextField and gradeMaxScoreTextField are numbers or not
//                let num1 = Float(gradeScoreTextField.text!)
//                let num2 = Float(gradeMaxScoreTextField.text!)
//
//                if ((num1 != nil) && (num2 != nil) && (gradeNameTextField.text! != ""))
//                {
//                    // grade percent
//                    let percent = (Float(gradeScoreTextField.text!)! / Float(gradeMaxScoreTextField.text!)!) * 100
//
//                    let newGrade = GradeTableView(gradeName: gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
//                    self.gradeArray[indexPath.row] = newGrade
//                    self.tableView.reloadData()
//                    self.editGrade(indexPath.row, gradeName: gradeNameTextField.text!, gradeScore: Float(gradeScoreTextField.text!)!, gradeMaxScore: Float(gradeMaxScoreTextField.text!)!, gradePercent: percent)
//                    self.categoryPrecentage()
//                    // Close the View
                    editAlertView.hideView()
//                }
            }
            
            editAlertView.addButton("Cancel") {
                editAlertView.hideView()
            }
            
            editAlertView.showTitle("Assignment", subTitle: "Editing a Assignment", style: .edit)
            gradeNameTextField.becomeFirstResponder()
            
        }
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

