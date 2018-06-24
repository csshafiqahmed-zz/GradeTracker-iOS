//
//  GradeRealm.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/23/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import RealmSwift

class GradeRealm: Object {
    @objc dynamic var gradeName: String = String()
    @objc dynamic var gradeScore: Float = Float()
    @objc dynamic var gradeMaxScore: Float = Float()
    @objc dynamic var gradePercent: Float = Float()
}
