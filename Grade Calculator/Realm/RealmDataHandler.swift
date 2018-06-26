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
        
    }
    
    /**
     *
     */
    public static func deleteCategoryRealmObject(_ categoryRealm: CategoryRealm) {
        
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
        }
    }
    
    /**
     *
     */
    public static func editGradeRealmObject(_ gradeRealm: GradeRealm) {
        
    }
    
    /**
     *
     */
    public static func deleteGradeRealmObject(_ gradeRealm: GradeRealm) {
        
    }
    
}
