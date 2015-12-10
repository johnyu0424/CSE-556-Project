//
//  Person.swift
//  CSE 556 Project
//
//  Created by John Yu on 12/9/15.
//  Copyright © 2015 Emtae. All rights reserved.
//

import UIKit

class Person: NSObject {
    var key: String
    var rating: Rating
    var preference: Preference
    
    init(key: String, rating: Rating, preference: Preference) {
        self.key = key
        self.rating = rating
        self.preference = preference
    }
    
    func convertToDict() -> [String: [String: [Float]]]
    {
        let data: [String: [Float]] =
        [
            self.rating.key: self.rating.value,
            self.preference.key : self.preference.value
        ]
        return [self.key: data]
    }
}
