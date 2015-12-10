//
//  ViewController.swift
//  CSE 556 Project
//
//  Created by John Yu on 12/8/15.
//  Copyright © 2015 Emtae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var rating: Rating!
    var preference: Preference!
    var user: PFUser?
    var entireData: [Person]!
    var parseData: [PFObject]!
    var index: Int!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.rating = Rating(value: [])
        self.preference = Preference(value: [])
    }
    
    override func viewWillAppear(animated: Bool) {
        self.entireData = []
        self.user = PFUser.currentUser()
        if (self.user == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
        
        else
        {
            let query = PFQuery(className:"Data")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) data.")
                    self.parseData = objects!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                         self.processParseData()
                    })
                }
                    
                else
                {
                    if error!.code == PFErrorCode.ErrorObjectNotFound.rawValue
                    {
                        self.rating = Rating(value: [])
                        self.preference = Preference(value: [])
                    }
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }
    
    func processParseData()
    {
        var i = 0
        
        for object in self.parseData
        {
            let user = (object["user"] as! PFUser)
            
            do
            {
                try user.fetchIfNeeded()
            }
            catch
            {
                
            }
            
            if (object["user"] as! PFUser).username! == self.user!.username
            {
                self.rating.value = object["rating"] as! [Float]
                self.preference.value = object["preference"] as! [Float]
                self.index = i
            }
            
            self.entireData.append(convertFromPFObjectToPerson(object))
            
            i++
        }
        
        if self.parseData!.count == 0
        {
            self.rating = Rating(value: [])
            self.preference = Preference(value: [])
            self.index = 0
        }
    }

    func convertFromPFObjectToPerson(object: PFObject) -> Person
    {
        let r = Rating(value: object["rating"] as! [Float])
        let p = Preference(value: object["preference"] as! [Float])
        let username = (object["user"] as! PFUser)["username"] as! String
        
        return Person(key: username, rating: r , preference: p)
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RatingSegue"
        {
            let destVC = segue.destinationViewController as! RatingVC
            destVC.rating = self.rating
        }
        
        else if segue.identifier == "PreferenceSegue"
        {
            let destVC = segue.destinationViewController as! PreferenceVC
            destVC.preference = self.preference
        }
        
        else if segue.identifier == "MatchSegue"
        {
            let destVC = segue.destinationViewController as! MatchVC
            destVC.entireData = self.entireData
            destVC.userIndex = self.index
        }
    }

    @IBAction func logout(sender: AnyObject) {
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })

    }

}

