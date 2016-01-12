//
//  ReportIssueViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class ReportIssueViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let dataManager = DataManager.sharedInstance
    
    @IBOutlet weak var      issuePicker             :UIPickerView!
    @IBOutlet weak var      stationsPicker          :UIPickerView!
    @IBOutlet weak var      saveToParseButton       :UIBarButtonItem!
    var stationsLineArray = [Stations]()
    
    @IBOutlet var      blueButton              :UIButton!
    @IBOutlet var      greenButton             :UIButton!
    @IBOutlet var      orangeButton            :UIButton!
    @IBOutlet var      redButton               :UIButton!
    @IBOutlet var      silverButton            :UIButton!
    @IBOutlet var      yellowButton            :UIButton!
    
    @IBOutlet weak var selectLineLabel       :UILabel!
    @IBOutlet weak var selectStationLabel   :UILabel!
    @IBOutlet weak var selectIssueLabel     :UILabel!
    


    //MARK: - Camera Methods
    
    @IBOutlet weak var previewView :UIView!
    var captureSession :AVCaptureSession?
    var previewLayer :AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var capturedImage   :UIImageView!
    var stillImageOutput :AVCaptureStillImageOutput?
    
    
    func startCaptureSession () {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error :NSError?
        var input :AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput ()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            previewView.layer.addSublayer(previewLayer!)
            
            captureSession!.startRunning()
            
        }
    }
    
    @IBAction func didPressTakePhotoButton (sender: UIButton) {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = .Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Right)
                    self.capturedImage.image = image
                    self.saveToParseButton.enabled = true
                }
            })
        }
        
    }
    
    

 
    
    
    
    //MARK: - Picker View Methods
    
    var selectedIssue :PFObject!
    var selectedStation :Stations!
    var selectedReport :PFObject!
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == issuePicker {
            return dataManager.issuesArray.count
        } else if pickerView == stationsPicker {
            return stationsLineArray.count
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
            return stationsLineArray[row].stationName as String
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == issuePicker {
            let selection = issuePicker.selectedRowInComponent(0)
            selectedIssue = dataManager.issuesArray[selection]
        } else if pickerView == stationsPicker {
            let selection = stationsPicker.selectedRowInComponent(0)
            selectedStation = stationsLineArray[selection]
        }
    }
    
    
    //MARK: - Button Methods
    
    func filterDataForLine(line: String) {
        let tempArray1 = dataManager.stationsArray.filter({$0.stationLine1 == line || $0.stationLine2 == line})
        let tempArray2 = dataManager.stationsArray.filter({$0.stationLine3 == line || $0.stationLine4 == line})
        stationsLineArray.removeAll()
        stationsLineArray.appendContentsOf(tempArray1)
        stationsLineArray.appendContentsOf(tempArray2)
        stationsPicker.reloadAllComponents()
    }
    
    @IBAction func redButtonPressed(sender: UIButton)  {
        sender.selected = true
        blueButton.selected = !sender.selected
        greenButton.selected = !sender.selected
        orangeButton.selected = !sender.selected
        silverButton.selected = !sender.selected
        yellowButton.selected = !sender.selected
        self.selectLineLabel.backgroundColor = UIColor(red: 209/255, green: 18/255, blue: 66/255, alpha: 1.0)
        self.selectLineLabel.textColor = UIColor.whiteColor()
        self.selectStationLabel.backgroundColor = UIColor(red: 209/255, green: 18/255, blue: 66/255, alpha: 1.0)
        self.selectStationLabel.textColor = UIColor.whiteColor()
        self.selectIssueLabel.backgroundColor = UIColor(red: 209/255, green: 18/255, blue: 66/255, alpha: 1.0)
        self.selectIssueLabel.textColor = UIColor.whiteColor()
        
        filterDataForLine("RD")
    }
    
    @IBAction func blueButtonPressed(sender: UIButton)  {
        sender.selected = true
        redButton.selected = !sender.selected
        greenButton.selected = !sender.selected
        orangeButton.selected = !sender.selected
        silverButton.selected = !sender.selected
        yellowButton.selected = !sender.selected
        self.selectLineLabel.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 171/255, alpha: 1.0)
        self.selectLineLabel.textColor = UIColor.whiteColor()
        self.selectStationLabel.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 171/255, alpha: 1.0)
        self.selectStationLabel.textColor = UIColor.whiteColor()
        self.selectIssueLabel.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 171/255, alpha: 1.0)
        self.selectIssueLabel.textColor = UIColor.whiteColor()
        

        filterDataForLine("BL")
    }
    
    @IBAction func greenButtonPressed(sender: UIButton)  {
        sender.selected = true
        redButton.selected = !sender.selected
        blueButton.selected = !sender.selected
        orangeButton.selected = !sender.selected
        silverButton.selected = !sender.selected
        yellowButton.selected = !sender.selected
        self.selectLineLabel.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 89/255, alpha: 1.0)
        self.selectLineLabel.textColor = UIColor.whiteColor()
        self.selectStationLabel.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 89/255, alpha: 1.0)
        self.selectStationLabel.textColor = UIColor.whiteColor()
        self.selectIssueLabel.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 89/255, alpha: 1.0)
        self.selectIssueLabel.textColor = UIColor.whiteColor()

        filterDataForLine("GR")
    }
    
    @IBAction func silverButtonPressed(sender: UIButton)  {
        sender.selected = true
        redButton.selected = !sender.selected
        greenButton.selected = !sender.selected
        orangeButton.selected = !sender.selected
        blueButton.selected = !sender.selected
        yellowButton.selected = !sender.selected
        self.selectLineLabel.backgroundColor = UIColor(red: 161/255, green: 165/255, blue: 163/255, alpha: 1.0)
        self.selectLineLabel.textColor = UIColor.whiteColor()
        self.selectStationLabel.backgroundColor = UIColor(red: 161/255, green: 165/255, blue: 163/255, alpha: 1.0)
        self.selectStationLabel.textColor = UIColor.whiteColor()
        self.selectIssueLabel.backgroundColor = UIColor(red: 161/255, green: 165/255, blue: 163/255, alpha: 1.0)
        self.selectIssueLabel.textColor = UIColor.whiteColor()
        
        filterDataForLine("SV")
    }
    
    @IBAction func orangeButtonPressed(sender: UIButton)  {
        sender.selected = true
        redButton.selected = !sender.selected
        greenButton.selected = !sender.selected
        blueButton.selected = !sender.selected
        silverButton.selected = !sender.selected
        yellowButton.selected = !sender.selected
        self.selectLineLabel.backgroundColor = UIColor(red: 248/255, green: 151/255, blue: 29/255, alpha: 1.0)
        self.selectLineLabel.textColor = UIColor.whiteColor()
        self.selectStationLabel.backgroundColor = UIColor(red: 248/255, green: 151/255, blue: 29/255, alpha: 1.0)
        self.selectStationLabel.textColor = UIColor.whiteColor()
        self.selectIssueLabel.backgroundColor = UIColor(red: 248/255, green: 151/255, blue: 29/255, alpha: 1.0)
        self.selectIssueLabel.textColor = UIColor.whiteColor()
        
        filterDataForLine("OR")
    }
    
    @IBAction func yellowButtonPressed(sender: UIButton)  {
        sender.selected = true
        redButton.selected = !sender.selected
        greenButton.selected = !sender.selected
        orangeButton.selected = !sender.selected
        silverButton.selected = !sender.selected
        blueButton.selected = !sender.selected
        self.selectLineLabel.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 0/255, alpha: 1.0)
        self.selectLineLabel.textColor = UIColor.whiteColor()
        self.selectStationLabel.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 0/255, alpha: 1.0)
        self.selectStationLabel.textColor = UIColor.whiteColor()
        self.selectIssueLabel.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 0/255, alpha: 1.0)
        self.selectIssueLabel.textColor = UIColor.whiteColor()
        
        filterDataForLine("YL")
    }
    
    
    
    
    


    
    
    //MARK: - Save to Parse Methods
    
   
    @IBOutlet weak var timePicker   :UIDatePicker!
    
    @IBAction func saveToParse(sender: UIBarButtonItem) {
    
        let issuesReported = PFObject (className: "IssueReported")
        issuesReported["Station"] = stationsLineArray[stationsPicker.selectedRowInComponent(0)].stationName
        issuesReported["Issue"] = dataManager.issuesArray[issuePicker.selectedRowInComponent(0)]["issueName"]
        var line = ""
        if redButton.selected {
            line = "RD"
        } else if blueButton.selected {
            line = "BL"
        } else if greenButton.selected {
            line = "GR"
        } else if orangeButton.selected {
            line = "OR"
        } else if silverButton.selected {
            line = "SV"
        } else if yellowButton.selected {
            line = "YL"
        }
        
        issuesReported["Line"] = line
        
        if let imageCaptured = capturedImage.image {
            let imageData = UIImageJPEGRepresentation(imageCaptured, 1.0)
            let uuid = NSUUID().UUIDString
            let imageFile = PFFile(name: uuid, data:imageData!)
            
            
            issuesReported["imageFile"] = imageFile
        }
        
        issuesReported.saveInBackground()
        saveToParseButton.enabled = true
        
        
        
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    func newIssueDataReceived () {
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.fetchIssuesFromParse()
        filterDataForLine("RD")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newIssueDataReceived", name: "receivedIssueDataFromServer", object: nil)

        saveToParseButton.enabled = false
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        previewLayer!.frame = previewView.bounds
    }

  
}
