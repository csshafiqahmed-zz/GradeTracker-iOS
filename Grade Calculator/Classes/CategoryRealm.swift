//
//  CategoryRealm.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/23/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import RealmSwift

public class CategoryRealm: Object {
    @objc dynamic var classId: String = String()
    @objc dynamic var categoryId: String = String()
    @objc dynamic var categoryName: String = String()
    @objc dynamic var categoryWeight: Float = Float()
    @objc dynamic var categoryAverage: Float = Float()
//    @objc dynamic var categoryGrades: [GradeRealm] = [GradeRealm]()
}
