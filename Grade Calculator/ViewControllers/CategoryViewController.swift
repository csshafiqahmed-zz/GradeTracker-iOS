//
//  CategoryViewController.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/19/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

class CategoryViewController: UIViewController {
    
    /**
     *  UIElements
     */
    private var addButton: UIBarButtonItem!
    private var tableView: UITableView!
    
    private var categoryArray: [CategoryRealm] = [CategoryRealm]()
    var classRealm: ClassRealm = ClassRealm()
    
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
        pullCategoryRealmObjects()
    }
    
    private func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = "Category"
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
        let categoryNameTextField = addAlertView.addTextField("Enter Category Name")
        let cateogryWeightTextField = addAlertView.addTextField("Enter Category Weight")
        cateogryWeightTextField.keyboardType = UIKeyboardType.decimalPad
        
        addAlertView.addButton("Save") {
            let num1 = Float(cateogryWeightTextField.text!)
            if categoryNameTextField.text! != "" && num1 != nil {
                let newCategory = CategoryRealm()
                newCategory.classId = self.classRealm.classId
                newCategory.categoryName = categoryNameTextField.text!
                newCategory.categoryWeight = Float(cateogryWeightTextField.text!)!
                newCategory.categoryAverage = -100
    
                self.categoryArray.append(newCategory)
                self.tableView.reloadData()
                
                let realmCategory = CategoryRealm()
                realmCategory.classId = newCategory.classId
                realmCategory.categoryId = newCategory.categoryId
                realmCategory.categoryName = newCategory.categoryName
                realmCategory.categoryWeight = newCategory.categoryWeight
                realmCategory.categoryAverage = newCategory.categoryAverage
                RealmDataHandler.addNewCategoryRealmObject(realmCategory)
                
                addAlertView.hideView()
            }
        }
        addAlertView.addButton("Cancel") {
            addAlertView.hideView()
        }
        addAlertView.showInfo("Category", subTitle: "Adding a New Category")
    }
    
    private func pullCategoryRealmObjects() {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "classId = %@", classRealm.classId as CVarArg)
        let categoryRealmObjects = realm.objects(CategoryRealm.self).filter(predicate)
        categoryArray = Array(categoryRealmObjects)
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

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryTableViewCell(style: .default, reuseIdentifier: "cell")
        let category = categoryArray[indexPath.item]
        cell.categoryNameLabel.text = category.categoryName
        cell.categoryWeightLabel.text = String(format: "%.2f", category.categoryWeight)
        cell.categoryAverageLabel.text = (category.categoryAverage < 0) ? "--%" : String(format: "%.2f", category.categoryAverage) + "%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = GradeViewController()
        viewController.categoryRealm = categoryArray[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            RealmDataHandler.deleteCategoryRealmObject(self.categoryArray[indexPath.item].categoryId)
            self.categoryArray.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let selectedCategory = self.categoryArray[indexPath.row]
            // Custom AlertView
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false, shouldAutoDismiss: false
            )
            let editAlertView = SCLAlertView(appearance: appearance)
            let categoryNameTextField = editAlertView.addTextField("Enter Category Name")
            let cateogryWeightTextField = editAlertView.addTextField("Enter Category Weight")
            cateogryWeightTextField.keyboardType = UIKeyboardType.decimalPad
            categoryNameTextField.text = selectedCategory.categoryName
            cateogryWeightTextField.text = String(selectedCategory.categoryWeight)
            
            editAlertView.addButton("Save") {
                let num1 = Float(cateogryWeightTextField.text!)
                if ((categoryNameTextField.text! != "") && (num1 != nil)) {
                    let newCategory = CategoryRealm()
                    newCategory.classId = selectedCategory.classId
                    newCategory.categoryId = selectedCategory.categoryId
                    newCategory.categoryName = categoryNameTextField.text!
                    newCategory.categoryWeight = num1!
                    newCategory.categoryAverage = selectedCategory.categoryAverage
                    self.categoryArray[indexPath.row] = newCategory
                    self.tableView.reloadData()
                    RealmDataHandler.editCategoryRealmObject(newCategory)
                    editAlertView.hideView()
                }
            }
            editAlertView.addButton("Cancel") {
                editAlertView.hideView()
            }
            editAlertView.showTitle("Category", subTitle: "Editing a Category", style: .edit)
            categoryNameTextField.becomeFirstResponder()
        }
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        let weightLabel = UILabel()
        weightLabel.text = "Weight"
        weightLabel.textColor = .white
        weightLabel.textAlignment = .left
        weightLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false

        let averageLabel = UILabel()
        averageLabel.text = "Average"
        averageLabel.textColor = .white
        averageLabel.textAlignment = .right
        averageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        averageLabel.translatesAutoresizingMaskIntoConstraints = false

        let headerView = UIView()
        headerView.backgroundColor = .gray
        headerView.addSubview(categoryLabel)
        headerView.addSubview(weightLabel)
        headerView.addSubview(averageLabel)

        headerView.addConstraintsWithFormat(format: "H:|-10-[v0]-30-[v1(70)]-30-[v2(70)]-10-|", views: categoryLabel, weightLabel, averageLabel)
        headerView.addConstraintsWithFormat(format: "V:|[v0]|", views: categoryLabel)
        headerView.addConstraintsWithFormat(format: "V:|[v0]|", views: weightLabel)
        headerView.addConstraintsWithFormat(format: "V:|[v0]|", views: averageLabel)
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
