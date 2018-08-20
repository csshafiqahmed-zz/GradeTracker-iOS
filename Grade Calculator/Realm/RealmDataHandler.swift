//
//  RealmDataHandler.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/23/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmDataHandler {
    
    /**
     *
     */
    public static func addNewClassRealmObject(_ classRealm: ClassRealm) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            realm.beginWrite()
            realm.add(classRealm)
            try! realm.commitWrite()
        }
    }
    
    /**
     *
     */
    public static func editClassRealmObject(_ classRealm: ClassRealm) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "classId = %@", classRealm.classId as CVarArg)
            let queryResults = realm.objects(ClassRealm.self).filter(predicate)
            if queryResults.count > 0 && queryResults.first?.classId == classRealm.classId {
                try! realm.write {
                    queryResults.first?.className = classRealm.className
                }
            }
        }
    }
    
    public static func updateClassAverage(_ classId: String) {
        DispatchQueue.global().sync {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "classId = %@", classId as CVarArg)
            let queryResults = realm.objects(ClassRealm.self).filter(predicate)
            if queryResults.count > 0 && queryResults.first?.classId == classId {
                let categoryResults = realm.objects(CategoryRealm.self).filter(predicate)
                try! realm.write {
                    queryResults.first?.classOverallGrade = Helper.calculateClassAverage(results: Array(categoryResults))
                }
            }
        }
    }
    
    /**
     *
     */
    public static func deleteClassRealmObject(_ classId: String) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "classId = %@", classId as CVarArg)
            let classRealmResults = realm.objects(ClassRealm.self).filter(predicate)
            let categoryRealmResults = realm.objects(CategoryRealm.self).filter(predicate)
            let gradesRealmResults = realm.objects(GradeRealm.self).filter(predicate)
            try! realm.write {
                realm.delete(classRealmResults)
                realm.delete(categoryRealmResults)
                realm.delete(gradesRealmResults)
            }
            
        }
    }
    
    /**
     *
     */
    public static func addNewCategoryRealmObject(_ categoryRealm: CategoryRealm) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            realm.beginWrite()
            realm.add(categoryRealm)
            try! realm.commitWrite()
        }
    }
    
    /**
     *
     */
    public static func editCategoryRealmObject(_ categoryRealm: CategoryRealm) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "categoryId = %@", categoryRealm.categoryId as CVarArg)
            let queryResults = realm.objects(CategoryRealm.self).filter(predicate)
            if queryResults.count > 0 && queryResults.first?.categoryId == categoryRealm.categoryId {
                let gradeResults = realm.objects(GradeRealm.self).filter(predicate)
                try! realm.write {
                    queryResults.first?.categoryName = categoryRealm.categoryName
                    queryResults.first?.categoryWeight = categoryRealm.categoryWeight
                    queryResults.first?.categoryAverage = Helper.calculateCategoryAverage(results: Array(gradeResults), weight: categoryRealm.categoryWeight)
                }
                self.updateClassAverage((queryResults.first?.classId)!)
            }
        }
    }
    
    public static func updateCategoryAverage(_ categoryId: String) {
        DispatchQueue.global().sync {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "categoryId = %@", categoryId as CVarArg)
            let queryResults = realm.objects(CategoryRealm.self).filter(predicate)
            if queryResults.count > 0 && queryResults.first?.categoryId == categoryId {
                let gradeResults = realm.objects(GradeRealm.self).filter(predicate)
                try! realm.write {
                    queryResults.first?.categoryAverage = Helper.calculateCategoryAverage(results: Array(gradeResults), weight: (queryResults.first?.categoryWeight)!)
                }
                self.updateClassAverage((queryResults.first?.classId)!)
            }
        }
    }
    
    /**
     *
     */
    public static func deleteCategoryRealmObject(_ categoryId: String) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "categoryId = %@", categoryId as CVarArg)
            let categoryRealmResults = realm.objects(CategoryRealm.self).filter(predicate)
            let gradesRealmResults = realm.objects(GradeRealm.self).filter(predicate)
            try! realm.write {
                realm.delete(categoryRealmResults)
                realm.delete(gradesRealmResults)
            }
            self.updateClassAverage((categoryRealmResults.first?.classId)!)
        }
    }
    
    /**
     *
     */
    public static func addNewGradeRealmObject(_ gradeRealm: GradeRealm) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            realm.beginWrite()
            realm.add(gradeRealm)
            try! realm.commitWrite()
            self.updateCategoryAverage(gradeRealm.categoryId)
        }
    }
    
    /**
     *
     */
    public static func editGradeRealmObject(_ gradeRealm: GradeRealm) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "gradeId = %@", gradeRealm.gradeId as CVarArg)
            let queryResults = realm.objects(GradeRealm.self).filter(predicate)
            if queryResults.count > 0 && queryResults.first?.gradeId == gradeRealm.gradeId {
                try! realm.write {
                    queryResults.first?.gradeName = gradeRealm.gradeName
                    queryResults.first?.gradeScore = gradeRealm.gradeScore
                    queryResults.first?.gradeMaxScore = gradeRealm.gradeMaxScore
                    queryResults.first?.gradePercent = gradeRealm.gradeScore / gradeRealm.gradeMaxScore
                }
                self.updateCategoryAverage((queryResults.first?.categoryId)!)
            }
        }
    }
    
    /**
     *
     */
    public static func deleteGradeRealmObject(gradeId: String, categoryId: String) {
        DispatchQueue.global().async {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "gradeId = %@", gradeId as CVarArg)
            let gradesRealmResults = realm.objects(GradeRealm.self).filter(predicate)
            try! realm.write {
                realm.delete(gradesRealmResults)
            }
            updateCategoryAverage(categoryId)
        }
    }
    
}
