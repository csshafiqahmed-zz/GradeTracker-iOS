//
//  Class+CoreDataProperties.swift
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

extension Class {

    @NSManaged var classname: String?
    @NSManaged var overallGrade: NSNumber?
    @NSManaged var category: NSMutableOrderedSet?

}
