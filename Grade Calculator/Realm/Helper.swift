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
    
}
