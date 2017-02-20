//
//  TableViewClasses.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 8/13/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ClassTableView {
    var className : String
    var overallGrade : Float
    
    init(className: String, overallGrade: Float) {
        self.className = className
        self.overallGrade = overallGrade
    }
}

class CategoryTableView {
    var categoryName : String
    var categoryWeight : Float
    var categoryAverage : Float
    
    init(categoryName: String, categoryWeight: Float, categoryAverage: Float) {
        self.categoryName = categoryName
        self.categoryWeight = categoryWeight
        self.categoryAverage = categoryAverage
    }
}

class GradeTableView {
    var gradeName : String
    var gradeScore : Float
    var gradeMaxScore : Float
    var gradePercent : Float
    
    init(gradeName: String, gradeScore: Float, gradeMaxScore: Float, gradePercent: Float) {
        self.gradeName = gradeName
        self.gradeScore = gradeScore
        self.gradeMaxScore = gradeMaxScore
        self.gradePercent = gradePercent
    }
}
