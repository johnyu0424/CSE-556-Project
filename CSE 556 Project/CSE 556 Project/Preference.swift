//
//  Preference.swift
//  CSE 556 Project
//
//  Created by John Yu on 12/9/15.
//  Copyright © 2015 Emtae. All rights reserved.
//

import UIKit

class Preference: NSObject {
    var key: String
    var value: [Float]
    
    init(value: [Float]) {
        self.key = "preference"
        self.value = value
    }
}
