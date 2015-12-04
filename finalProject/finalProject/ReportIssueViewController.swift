//
//  ReportIssueViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse

class ReportIssueViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let dataManager = DataManager.sharedInstance
    
    @IBOutlet weak var      issuePicker             :UIPickerView!
    @IBOutlet weak var      stationsPicker          :UIPickerView!
    @IBOutlet weak var      saveToParseButton       :UIBarButtonItem!
    
    @IBOutlet var      blueButton              :UIButton!
    @IBOutlet var      greenButton             :UIButton!
    @IBOutlet var      orangeButton            :UIButton!
    @IBOutlet var      redButton               :UIButton!
    @IBOutlet var      silverButton            :UIButton!
    @IBOutlet var      yellowButton            :UIButton!
    


//    //MARK: - Camera Methods
//    
//    
//    @IBAction func cameraButtonTapped (sender: UIBarButtonItem) {
//        print("Camera button Tapped")
//        let imagePicker = UIImagePickerController()
//        if imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
//        [self .presentViewController(imagePicker, animated: true, completion: nil)]
//        } else {
//        print("Warning - no camera")
//        }
//    }
//
//    
//    @IBAction func galleryButtonTapped (sender: UIBarButtonItem) {
//        print("Gallery Button Tapped")
//        let imagePicker = UIImagePickerController()
//        if imagePicker.sourceType == UIImagePickerControllerSourceType.SavedPhotosAlbum {
//            [self .presentViewController(imagePicker, animated: true, completion: nil)]
//        } else {
//            print("No gallery")
//        }
//    }
    
    

 
    
    
    
    //MARK: - Picker View Methods
    
    var selectedIssue :PFObject!
    var selectedStation :Stations!
    var selectedReport :PFObject!
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == issuePicker {
            return dataManager.issuesArray.count
        } else if pickerView == stationsPicker {
            return dataManager.stationsArray.count
        }
        return 0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == issuePicker {
            return dataManager.issuesArray[row].objectForKey("issueName") as? String
        } else if pickerView == stationsPicker {
            return dataManager.stationsArray[row].stationName as String
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == issuePicker {
            let selection = issuePicker.selectedRowInComponent(0)
            selectedIssue = dataManager.issuesArray[selection]
        } else if pickerView == stationsPicker {
            let selection = stationsPicker.selectedRowInComponent(0)
            selectedStation = dataManager.stationsArray[selection]
        }
    }
    
    
    //MARK: - Button Methods
    
    
    func setRedButtonColor () {
        redButton.backgroundColor = UIColor(red: 209/255, green: 18/255, blue: 66/255, alpha: 1.0)
    }
 
    func setYellowColor () {
        yellowButton.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 0/255, alpha: 1.0)
    }
    
    func setOrangeColor () {
        orangeButton.backgroundColor = UIColor(red: 248/255, green: 151/255, blue: 29/255, alpha: 1.0)
    }
    
    func setGreenColor () {
        greenButton.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 89/255, alpha: 1.0)
    }
    
    func setBlueColor () {
        blueButton.backgroundColor = UIColor(red: 0/255, green: 18/255, blue: 214/255, alpha: 1.0)
    }
    
    func setSilverColor () {
        silverButton.backgroundColor = UIColor(red: 161/255, green: 165/255, blue: 163/255, alpha: 1.0)
    }
    
    
    //MARK: - Save to Parse Methods
    
    
    @IBAction func saveToParse(sender: UIBarButtonItem) {
        let issuesReported = PFObject (className: "IssueReported")
        issuesReported["Station"] = dataManager.stationsArray[stationsPicker.selectedRowInComponent(0)].stationName
        issuesReported["Issue"] = dataManager.issuesArray[issuePicker.selectedRowInComponent(0)]["issueName"]
//        issuesReported["Line"] = 
        issuesReported.saveInBackground()
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    
    
    
    
    
    
    func newIssueDataReceived () {
        print("New Issue Data Received")
        
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newIssueDataReceived", name: "receivedIssueDataFromServer", object: nil)
        self.setBlueColor()
        self.setGreenColor()
        self.setRedButtonColor()
        self.setOrangeColor()
        self.setYellowColor()
        self.setSilverColor()   

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
}
