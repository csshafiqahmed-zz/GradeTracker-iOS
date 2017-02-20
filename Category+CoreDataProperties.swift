//
//  Category+CoreDataProperties.swift
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

extension Category {

    @NSManaged var categoryAverage: NSNumber?
    @NSManaged var categoryName: String?
    @NSManaged var categoryWeight: NSNumber?
    @NSManaged var classes: Class?
    @NSManaged var grade: NSMutableOrderedSet?

}
