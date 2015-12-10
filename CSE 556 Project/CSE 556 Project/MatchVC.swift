//
//  MatchVC.swift
//  CSE 556 Project
//
//  Created by John Yu on 12/8/15.
//  Copyright © 2015 Emtae. All rights reserved.
//

import UIKit

class MatchVC: UIViewController {
    
    var entireData: [Person]!
    var userIndex: Int!
    var maleUserData: [Person]!
    var femaleUserData: [Person]!
    var maleTotalScore: [String: [String: Float]]!
    var femaleTotalScore:[String: [String: Float]]!
    var maleRank: [String: [(String, Float)]]!
    var femaleRank: [String: [(String, Float)]]!
    
    @IBOutlet var matchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maleUserData = [Person]()
        self.femaleUserData = [Person]()
        self.maleTotalScore = [String: [String: Float]]()
        self.femaleTotalScore = [String: [String: Float]]()
        self.maleRank = [String: [(String, Float)]]()
        self.femaleRank = [String: [(String, Float)]]()
        
        self.splitData()
        
        self.maleTotalScore = self.calcUserTotalScore(self.maleUserData, secondData: self.femaleUserData)
        self.femaleTotalScore = self.calcUserTotalScore(self.femaleUserData, secondData: self.maleUserData)
        
        self.maleRank = self.rankUser(self.maleTotalScore)
        self.femaleRank = self.rankUser(self.femaleTotalScore)
        print(self.maleRank)
        print(self.femaleRank)
        
        let user = self.entireData[self.userIndex].key
        let engage = self.matchMaker()
        
        print(engage)
        
        
        self.matchLabel.text = "You are matched with \(self.findPartner(engage, user: user))"
    }
    
    func findPartner(engagments: [String: String], user: String) -> String
    {
        for (key, value) in engagments
        {
            if value == user
            {
                return key
            }
        }
        
        return ""
    }
    
    func splitData()
    {
        let midPoint = self.entireData.count/2 - 1
        
        if self.entireData.count % 2 == 0
        {
            if self.userIndex <= midPoint
            {
                for var i = 0; i < self.entireData.count; i++
                {
                    if i <= midPoint
                    {
                        self.maleUserData.append(self.entireData[i])
                    }
                        
                    else
                    {
                        self.femaleUserData.append(self.entireData[i])
                    }
                }
            }
                
            else
            {
                for var i = 0; i < self.entireData.count; i++
                {
                    if i > midPoint
                    {
                        self.maleUserData.append(self.entireData[i])
                    }
                        
                    else
                    {
                        self.femaleUserData.append(self.entireData[i])
                    }
                }
            }
        }
            
        else
        {
            let fakePerson = Person(key: "Computer", rating: Rating(value: [46, 51, 0, 2, 1]), preference: Preference(value:[4, 6, 1, 2, 3]))
            self.entireData.append(fakePerson)
            
            let midPoint2 = self.entireData.count/2 - 1
            
            if self.userIndex <= midPoint2
            {
                for var i = 0; i < self.entireData.count; i++
                {
                    if i <= midPoint2
                    {
                        self.maleUserData.append(self.entireData[i])
                    }
                        
                    else
                    {
                        self.femaleUserData.append(self.entireData[i])
                    }
                }
            }
                
            else
            {
                for var i = 0; i < self.entireData.count; i++
                {
                    if i > midPoint2
                    {
                        self.maleUserData.append(self.entireData[i])
                    }
                        
                    else
                    {
                        self.femaleUserData.append(self.entireData[i])
                    }
                }
            }
        }
    }

    func rankUser(totalScores: [String: [String: Float]]) -> [String: [(String, Float)]]
    {
        var rank = [String: [(String, Float)]]()
        for (key, val) in totalScores
        {
            let totalScoreTuple = Array(Zip2Sequence(val.keys, val.values))
            rank[key] = bubbleSort(totalScoreTuple)
        }
        
        return rank
    }
    
    func bubbleSort(arr: [(String, Float)]) -> [(String, Float)]
    {
        var arrL = arr
        var flag = true
        
        while flag
        {
            flag = false
            for var i = 0; i < arrL.count; ++i
            {
                if i < arrL.count - 1 && arrL[i].1 < arrL[i+1].1
                {
                    let tmp = arrL[i]
                    arrL[i] = arrL[i+1]
                    arrL[i+1] = tmp
                }
            }
        }
        
        return arrL
    }
    
    
    func calcUserTotalScore(firstData: [Person], secondData: [Person]) -> [String: [String: Float]]
    {
        var userTotalScore = [String: [String: Float]]()
        
        for person in firstData
        {
            let totalScore = self.calcTotalScore(person, secondData: secondData)
            print("\(person.key)'s total score: ")
            print("\(totalScore)")
            
            userTotalScore[person.key] = totalScore
        }
        
        return userTotalScore
    }
    
    func calcTotalScore(firstData: Person, secondData: [Person]) -> [String: Float]
    {
        let interestRating = firstData.rating.value
        var totalScores = [String: Float]()
        
        for person in secondData
        {
            var totalScore: Float = 0.0
            for (i, val) in person.preference.value.enumerate()
            {
                totalScore = totalScore + (interestRating[i]/100.0 * val)
            }
            totalScores[person.key] = totalScore
        }
        
        return totalScores
    }
    
    func matchMaker() -> [String: String]
    {
        var engage = [String: String]()
        var maleFree = Array(self.maleRank.keys)
        var maleRankCopy = self.maleRank
        var femaleRankCopy = self.femaleRank

        while maleFree.count > 0
        {
            let male = maleFree.removeFirst()
            var maleList = maleRankCopy[male]!
            let female = maleList.removeFirst()
            maleRankCopy[male] = maleList // This is to copy the most updated list back to the male rank
            let fiance = engage[female.0]
            
            if fiance == nil
            {
                // She's free
                engage[female.0] = male
                print("\(male) and \(female)")
            }
            
            else
            {
                // The bounder proposes to an engaged lass!
                let femaleList = femaleRankCopy[female.0]!
                if self.findIndex(femaleList, data: fiance!) > self.findIndex(femaleList, data: male)
                {
                    // She prefers new guy
                    engage[female.0] = male
                    print("\(female) dumped \(fiance) for \(male)")
                    
                    if maleRankCopy[fiance!]?.count > 0
                    {
                        // Ex has more girls to try
                        maleFree.append(fiance!)
                    }
                }
                
                else
                {
                    // She is faithful to old fiance
                    if maleList.count > 0
                    {
                        // Look again
                        maleFree.append(male)
                    }
                }
            }
        }
        
        return engage
    }
    
    func findIndex(userData: [(String, Float)], data: String) -> Int
    {
        for i in 1..<userData.count
        {
            if userData[i].0 == data
            {
                return i
            }
        }
        
        return 0
    }
}


