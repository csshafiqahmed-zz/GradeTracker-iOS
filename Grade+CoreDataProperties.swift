//
//  Grade+CoreDataProperties.swift
//  
//
//  Created by Satish Boggarapu on 8/20/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Grade {

    @NSManaged var gradeName: String?
    @NSManaged var gradeScore: NSNumber?
    @NSManaged var gradeMaxScore: NSNumber?
    @NSManaged var gradePercent: NSNumber?
    @NSManaged var category: Category?

}
