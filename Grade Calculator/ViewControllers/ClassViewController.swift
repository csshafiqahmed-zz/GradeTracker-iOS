//
//  ClassViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/18/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

class ClassViewController: UIViewController {
    
    /**
     *  UI Elements
     */
    private var addButton: UIBarButtonItem!
    private var tableView: UITableView!
    
    private var classNameArray: [ClassRealm] = [ClassRealm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        print(realm.configuration.fileURL!.absoluteString)

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        pullClassRealmObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pullClassRealmObjects()
        tableView.reloadData()
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
            if (classNameTextField.text != "") {
                let newClass = ClassRealm()
                newClass.className = classNameTextField.text!
                newClass.classOverallGrade = -100.0
                self.classNameArray.append(newClass)
                self.tableView.reloadData()
                
                let realmClass = ClassRealm()
                realmClass.classId = newClass.classId
                realmClass.className = newClass.className
                realmClass.classOverallGrade = newClass.classOverallGrade
                RealmDataHandler.addNewClassRealmObject(realmClass)
                
                addAlertView.hideView()
            }
        }
        addAlertView.addButton("Cancel") {
            addAlertView.hideView()
        }
        addAlertView.showInfo("Class Name", subTitle: "Adding a New Class")
        
        classNameTextField.becomeFirstResponder()
    }
    
    private func pullClassRealmObjects() {
        let realm = try! Realm()
        let classRealmObjects = realm.objects(ClassRealm.self)
        classNameArray = Array(classRealmObjects)
        tableView.reloadData()
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
        return classNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ClassTableViewCell(style: .default, reuseIdentifier: "cell")
        let classRealm = classNameArray[indexPath.item]
        cell.classNameLabel.text = classRealm.className
        cell.classOverallGradeLabel.text = (classRealm.classOverallGrade < 0) ? "--%" : String(format: "%.2f", classRealm.classOverallGrade) + "%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CategoryViewController()
        viewController.classRealm = classNameArray[indexPath.item]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            RealmDataHandler.deleteClassRealmObject(self.classNameArray[indexPath.item].classId)
            self.classNameArray.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let classRealm = self.classNameArray[indexPath.item]
            // Custom AlertView
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false, shouldAutoDismiss: false
            )
            let editAlertView = SCLAlertView(appearance: appearance)
            let classNameTextField = editAlertView.addTextField("Enter a Class Name")
            classNameTextField.text = classRealm.className
            
            editAlertView.addButton("Save") {
                if (classNameTextField.text! != "") {
                    let newClass = ClassRealm()
                    newClass.classId = classRealm.classId
                    newClass.className = classNameTextField.text!
                    newClass.classOverallGrade = classRealm.classOverallGrade
                    self.classNameArray[indexPath.row] = newClass
                    self.tableView.reloadData()
                    RealmDataHandler.editClassRealmObject(newClass)
                    editAlertView.hideView()
                }
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
