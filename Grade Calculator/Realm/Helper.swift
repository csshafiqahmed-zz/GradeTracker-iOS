//
//  Helper.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/23/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

class Helper {
    
    static func generateRandomId() -> String {
        let length = 8
        let randomChars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let randomString = String((0..<length).map{ _ in randomChars[Int(arc4random_uniform(UInt32(randomChars.count)))]})
        return randomString
    }
    
    static func calculateClassAverage(results: [CategoryRealm]) -> Float {
        if results.count == 0 { return -100 }
        var actual: Float = 0
        var possible: Float = 0
        for category in results {
            actual += category.categoryAverage
            possible += category.categoryWeight
        }
        return (actual/possible)*100
    }
    
    static func calculateCategoryAverage(results: [GradeRealm], weight: Float) -> Float {
        if results.count == 0 { return -100 }
        var actual: Float = 0
        var possible: Float = 0
        for grade in results {
            actual += grade.gradeScore
            possible += grade.gradeMaxScore
        }
        return (actual/possible) * weight
    }
    
}
