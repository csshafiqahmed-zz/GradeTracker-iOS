//
//  ClassRealm.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/23/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import RealmSwift

class ClassRealm: Object {
    @objc dynamic var className: String = String()
    @objc dynamic var classOverallGrade: Float = Float()
    @objc dynamic var classCategories: [CategoryRealm] = [CategoryRealm]()
}
