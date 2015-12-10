//
//  RatingVC.swift
//  CSE 556 Project
//
//  Created by John Yu on 12/8/15.
//  Copyright © 2015 Emtae. All rights reserved.
//

import UIKit

class RatingVC: UIViewController {
    var interestV: Float!
    var rating: Rating!
    
    @IBOutlet var interest1Slider: UISlider!
    @IBOutlet var interest2Slider: UISlider!
    @IBOutlet var interest3Slider: UISlider!
    @IBOutlet var interest4Slider: UISlider!
    @IBOutlet var interest5Slider: UISlider!
    @IBOutlet var interest1Label: UILabel!
    @IBOutlet var interest2Label: UILabel!
    @IBOutlet var interest3Label: UILabel!
    @IBOutlet var interest4Label: UILabel!
    @IBOutlet var interest5Label: UILabel!
    @IBOutlet var totalLabel: UILabel!

    @IBAction func interest1SliderValueChanged(sender: AnyObject) {
        let intValue = round((sender as! UISlider).value / 1) * 1
        (sender as! UISlider).value = Float(intValue)
        
        self.interest1Label.text =  String(format: "%.0f", self.interest1Slider.value)
        calcInterestVC()
    }
    
    @IBAction func interest2SliderValueChanged(sender: AnyObject) {
        let intValue = round((sender as! UISlider).value / 1) * 1
        (sender as! UISlider).value = Float(intValue)
        
        self.interest2Label.text =  String(format: "%.0f", self.interest2Slider.value)
        calcInterestVC()
    }
    @IBAction func interest3SliderValueChanged(sender: AnyObject) {
        let intValue = round((sender as! UISlider).value / 1) * 1
        (sender as! UISlider).value = Float(intValue)

        
        self.interest3Label.text =  String(format: "%.0f", self.interest3Slider.value)
        calcInterestVC()
    }
    @IBAction func interest4SliderValueChanged(sender: AnyObject) {
        let intValue = round((sender as! UISlider).value / 1) * 1
        (sender as! UISlider).value = Float(intValue)

        
        self.interest4Label.text =  String(format: "%.0f", self.interest4Slider.value)
        calcInterestVC()
    }
    @IBAction func interest5SliderValueChanged(sender: AnyObject) {
        let intValue = round((sender as! UISlider).value / 1) * 1
        (sender as! UISlider).value = Float(intValue)

        
        self.interest5Label.text =  String(format: "%.0f", self.interest5Slider.value)
        calcInterestVC()
    }
    
    @IBAction func save(sender: AnyObject) {
        if interestV != 0
        {
            // cant save
            let alert = UIAlertController(title: "Error!", message: "Make sure the total only add up to 100", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        
        else
        {
            // save
            let user = PFUser.currentUser()
            let query = PFQuery(className:"Data")
            self.rating.value = [self.interest1Slider.value, self.interest2Slider.value, self.interest3Slider.value, self.interest4Slider.value, self.interest5Slider.value]
            
            query.whereKey("user", equalTo:user!)
            query.findObjectsInBackgroundWithBlock {
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
                            objects[0]["rating"] = self.rating.value
                            objects[0].saveInBackground()
                        }
                        
                        if objects.count == 0
                        {
                            let data = PFObject(className:"Data")
                            data["rating"] = self.rating.value
                            data["preference"] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestV = 100
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.rating.value.count > 0
        {
            self.interest1Slider.value = self.rating.value[0]
            self.interest1Label.text =  String(format: "%.0f", self.interest1Slider.value)
            self.interest2Slider.value = self.rating.value[1]
            self.interest2Label.text =  String(format: "%.0f", self.interest2Slider.value)
            self.interest3Slider.value = self.rating.value[2]
            self.interest3Label.text =  String(format: "%.0f", self.interest3Slider.value)
            self.interest4Slider.value = self.rating.value[3]
            self.interest4Label.text =  String(format: "%.0f", self.interest4Slider.value)
            self.interest5Slider.value = self.rating.value[4]
            self.interest5Label.text =  String(format: "%.0f", self.interest5Slider.value)
            
            self.calcInterestVC()
        }
    }
    
    func calcInterestVC()
    {
        self.interestV = 100 - self.interest1Slider.value - self.interest2Slider.value - self.interest3Slider.value - self.interest4Slider.value - self.interest5Slider.value
        self.totalLabel.text =  String(format: "%.0f", self.interestV)
    }
}
