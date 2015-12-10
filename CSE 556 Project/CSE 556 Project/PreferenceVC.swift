//
//  PreferenceVC.swift
//  CSE 556 Project
//
//  Created by John Yu on 12/8/15.
//  Copyright © 2015 Emtae. All rights reserved.
//

import UIKit

class PreferenceVC: UIViewController {
    var preference: Preference!
    
    @IBOutlet var interest1TextField: UITextField!
    @IBOutlet var interest2TextField: UITextField!
    @IBOutlet var interest3TextField: UITextField!
    @IBOutlet var interest4TextField: UITextField!
    @IBOutlet var interest5TextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(sender: AnyObject)
    {
        self.preference = Preference(value: [])
        self.preference.value.append(Float(self.interest1TextField.text!)!)
        self.preference.value.append(Float(self.interest2TextField.text!)!)
        self.preference.value.append(Float(self.interest3TextField.text!)!)
        self.preference.value.append(Float(self.interest4TextField.text!)!)
        self.preference.value.append(Float(self.interest5TextField.text!)!)
        
        if self.preference.value.count != Set(self.preference.value).count
        {
            // Don't save
            let alert = UIAlertController(title: "Error!", message: "Make sure no value is use more than once", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        else
        {
            // Save
            let user = PFUser.currentUser()
            let query = PFQuery(className:"Data")
            
            query.whereKey("user", equalTo:user!)
            query.findObjectsInBackgroundWithBlock{
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects
                    {
                        if objects.count == 1
                        {
                            objects[0]["preference"] = self.preference.value
                            objects[0].saveInBackground()
                        }
                        
                        if objects.count == 0
                        {
                            let data = PFObject(className:"Data")
                            data["preference"] = self.preference.value
                            data["rating"] = []
                            data["user"] = user!
                            data.saveInBackground()
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                else
                {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.preference.value.count > 0
        {
            self.interest1TextField.text = String(Int(self.preference.value[0]))
            self.interest2TextField.text = String(Int(self.preference.value[1]))
            self.interest3TextField.text = String(Int(self.preference.value[2]))
            self.interest4TextField.text = String(Int(self.preference.value[3]))
            self.interest5TextField.text = String(Int(self.preference.value[4]))
        }
    }
}
