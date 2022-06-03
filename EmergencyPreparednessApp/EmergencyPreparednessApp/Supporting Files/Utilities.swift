//
//  Utilities.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-27.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class Utilities{
    static func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
}
