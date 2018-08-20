//
//  GradeViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/19/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

class GradeViewController: UIViewController {
    
    /**
     *  UI Elements
     */
    private var addButton: UIBarButtonItem!
    private var tableView: UITableView!
    
    private var gradeArray: [GradeRealm] = [GradeRealm]()
    var categoryRealm: CategoryRealm = CategoryRealm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pullGradeRealmObjects()
    }
    
    private func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        self.navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.title = "Grades"
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
            let num1 = Float(gradeScoreTextField.text!)
            let num2 = Float(gradeMaxScoreTextField.text!)
            if ((num1 != nil) && (num2 != nil) && (gradeNameTextField.text! != ""))
            {
                let percent = (Float(gradeScoreTextField.text!)! / Float(gradeMaxScoreTextField.text!)!) * 100
                
                let newGrade = GradeRealm()
                newGrade.classId = self.categoryRealm.classId
                newGrade.categoryId = self.categoryRealm.categoryId
                newGrade.gradeName = gradeNameTextField.text!
                newGrade.gradeScore = Float(gradeScoreTextField.text!)!
                newGrade.gradeMaxScore = Float(gradeMaxScoreTextField.text!)!
                newGrade.gradePercent = percent
                
                self.gradeArray.append(newGrade)
                self.tableView.reloadData()

                let realmGrade = GradeRealm()
                realmGrade.classId = newGrade.classId
                realmGrade.categoryId = newGrade.categoryId
                realmGrade.gradeId = newGrade.gradeId
                realmGrade.gradeName = newGrade.gradeName
                realmGrade.gradeScore = newGrade.gradeScore
                realmGrade.gradeMaxScore = newGrade.gradeMaxScore
                realmGrade.gradePercent = newGrade.gradePercent
                RealmDataHandler.addNewGradeRealmObject(realmGrade)

                addAlertView.hideView()
            }
        }
        addAlertView.addButton("Cancel") {
            addAlertView.hideView()
        }
        addAlertView.showInfo("Assignment", subTitle: "Adding a New Assignment")
    }
    
    private func pullGradeRealmObjects() {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "categoryId = %@", categoryRealm.categoryId as CVarArg)
        let gradeRealmObjects = realm.objects(GradeRealm.self).filter(predicate)
        gradeArray = Array(gradeRealmObjects)
        tableView.reloadData()
    }

}

extension GradeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GradeTableViewCell(style: .default, reuseIdentifier: "cell")
        let grade = gradeArray[indexPath.item]
        cell.gradeNameLabel.text = grade.gradeName
        cell.gradeScoreLabel.text = String(grade.gradePercent)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let grade = self.gradeArray[indexPath.item]
            
            RealmDataHandler.deleteGradeRealmObject(gradeId: grade.gradeId, categoryId: grade.categoryId)
            self.gradeArray.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let selectedGrade = self.gradeArray[indexPath.row]
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
            gradeNameTextField.text = selectedGrade.gradeName
            gradeScoreTextField.text = String(selectedGrade.gradeScore)
            gradeMaxScoreTextField.text = String(selectedGrade.gradeMaxScore)
            
            editAlertView.addButton("Save") {
                let num1 = Float(gradeScoreTextField.text!)
                let num2 = Float(gradeMaxScoreTextField.text!)
                if ((num1 != nil) && (num2 != nil) && (gradeNameTextField.text! != "")) {
                    let percent = (Float(gradeScoreTextField.text!)! / Float(gradeMaxScoreTextField.text!)!) * 100
                    let newGrade = GradeRealm()
                    newGrade.classId = selectedGrade.classId
                    newGrade.categoryId = selectedGrade.categoryId
                    newGrade.gradeId = selectedGrade.gradeId
                    newGrade.gradeName = gradeNameTextField.text!
                    newGrade.gradeScore = num1!
                    newGrade.gradeMaxScore = num2!
                    newGrade.gradePercent = percent
                    self.gradeArray[indexPath.row] = newGrade
                    self.tableView.reloadData()
                    RealmDataHandler.editGradeRealmObject(newGrade)
                    editAlertView.hideView()
                }
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

