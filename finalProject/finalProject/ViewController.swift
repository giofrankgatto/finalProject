//
//  ViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import MapKit
//import CoreData

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
     //MARK: - Properties
    
    let networkManager = NetworkManager.sharedInstance
    let dataManager = DataManager.sharedInstance
    var selectedStationName :String!
    var selectedTrainName :String!
    var selectedLineName :String!
    var senderLine : String!
    
    
    
    @IBOutlet weak var          redButton                   :UIButton!
    @IBOutlet weak var          blueButton                  :UIButton!
    @IBOutlet weak var          yellowButton                :UIButton!
    @IBOutlet weak var          greenButton                 :UIButton!
    @IBOutlet weak var          silverButton                :UIButton!
    @IBOutlet weak var          orangeButton                :UIButton!
    
    
    @IBOutlet   weak var         stationMapView              :MKMapView!
    @IBOutlet   var              loginButton                 :UIBarButtonItem!
    
    
    
    
    //MARK: - User Default Methods
    
    func setUsernameDefault(username: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(username, forKey: "DefaultUsername")
        userDefaults.synchronize()
    }
    
    func getUserNameDefault() -> String {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let defaultUsername = userDefaults.stringForKey("DefaultUsername"){
            return defaultUsername
        } else {
            return ""
        }
    }
    
    //MARK: - Login Methods
    
    @IBAction func loginButtonPressed (sender: UIBarButtonItem) {
        print("Login Button Pressed")
        if let _ = PFUser.currentUser() {
            PFUser.logOut()
            loginButton.title = "Login"
        } else {
            
            let loginController = PFLogInViewController()
            loginController.delegate = self
            let signupController = PFSignUpViewController()
            signupController.delegate = self
            loginController.signUpController = signupController
            let username = getUserNameDefault()
            loginController.logInView?.usernameField?.text = username
            
            presentViewController(loginController, animated: true, completion: nil)
        }
    }
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        dismissViewControllerAnimated(true, completion: nil)
        let username = logInController.logInView!.usernameField!.text!
        setUsernameDefault(username)
        loginButton.title = "Log Out"
    }
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
   
    
    //MARK: - MapKit Methods
    
    var locationManager: CLLocationManager = CLLocationManager()
   
    
    func centerMapOnLocation(map:MKMapView) {
        print("Map on Location")
        let currentLocation = locationManager.location!.coordinate
        print(currentLocation)
        let center = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        map.setRegion(region, animated: true)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        centerMapOnLocation(stationMapView)
    }
    
    func turnOnLocationMonitoring() {
        print("starting monitoring")
        locationManager.startUpdatingLocation()
        stationMapView.showsUserLocation = true
    }
    
    func setupLocationMonitoring () {
        locationManager = CLLocationManager ()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if CLLocationManager.locationServicesEnabled() {
            print("LocSvcs Enabled")
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Always")
                turnOnLocationMonitoring()
            case .Denied, .Restricted:
                print("Hey User - turn us back on");
            case .NotDetermined:
                print("Not Determined")
                locationManager.requestWhenInUseAuthorization()
            }
            
        } else {
            print("Turn on Location Services in Settings");
        }
    }

    func annotateMapLocations() {
        var pinsToRemove = [MKAnnotation]()
        for annot: MKAnnotation in stationMapView.annotations {
            if annot.isKindOfClass(MKPointAnnotation) {
                pinsToRemove.append(annot)
            }
        }
        stationMapView.removeAnnotations(pinsToRemove)
        
        var pinsToAdd = [MKAnnotation]()
        for station in dataManager.stationsArray {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(Double(station.stationLat)!, Double(station.stationLon)!)
            pin.title = station.stationName
            pin.subtitle = station.stationStreet
            pinsToAdd.append(pin)
        }
        stationMapView.addAnnotations(pinsToAdd)
    }
   
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isMemberOfClass(MKUserLocation.self) {
            return nil
        } else {
            let identifier = "pin"
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if pin == nil {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pin!.canShowCallout = true
                pin!.pinTintColor = UIColor.blueColor()
                pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            pin!.annotation = annotation
            return pin
        }
    }
    
  
    
    //MARK: - Segue Methods
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Tapped")
        self.selectedStationName = view.annotation!.title!
        self.selectedTrainName = view.annotation!.title!
        self.performSegueWithIdentifier("segueStationDetail", sender: self)
        print("segue to station")
    }
    

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueStationDetail" {
            let destController = segue.destinationViewController as! StationInfoViewController
            destController.currentStation = dataManager.getStationWithName(selectedStationName)
            print(selectedStationName)
        } else if segue.identifier == "segueLineIssue" {
            let destController = segue.destinationViewController as! LineIssuesViewController
            
            redButton.tag = 1
            blueButton.tag = 2
            greenButton.tag = 3
            orangeButton.tag = 4
            silverButton.tag = 5
            yellowButton.tag = 6
            
            switch sender!.tag {
            case 1:
                senderLine = "RD"
            case 2:
                senderLine = "BL"
            case 3:
                senderLine = "GR"
            case 4:
                senderLine = "OR"
            case 5:
                senderLine = "SV"
            case 6:
                senderLine = "YL"
            default:
                print("Not segueing")
                
                
            }
            
            destController.currentLine = senderLine
            
            
            
        }
    }
   
    
    

    //MARK: - Get Data Methods
    
//    @IBAction func getDataSearchButton(sender: UIBarButtonItem) {
//        if networkManager.serverAvailable {
//            print ("server available")
//            dataManager.getDataFromServer()
//        } else {
//            print("Server Not Available")
//        }
//    }
    
    func getStationList() {
        if networkManager.serverAvailable {
            print("server available - station list")
            dataManager.getStationListFromServer()
        } else {
            print("server is not available - station list")
        }
    }

    
//    //MARK: - Core Data Methods
//    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let managedObjectContext :NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    var stationsArray = [MetroStation] ()
//    
//    func tempAddRecords () {
//        let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("MetroStation", inManagedObjectContext: managedObjectContext)
//        let currentStation : MetroStation! = MetroStation(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
//        
//        currentStation.stationName = "Addison Road-Seat Pleasant"
//        currentStation.stationLine1 = "Silver"
//        currentStation.stationLine2 = "Blue"
//        currentStation.stationLat = "38.886713"
//        currentStation.stationLon = "-76.893592"


    
    func fetchLineReportsFromParse(selectedLine: String) {
        let fetchIssues = PFQuery(className: "IssueReported")
        fetchIssues.whereKey("Line", matchesRegex: selectedLine)
        
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print(objects)
                print ("Got Line Data")
//                self.reportedLineIssuesArray = objects!
//                dispatch_async(dispatch_get_main_queue()) {
//                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedLineIssueDataFromServer", object: nil))
//                    
//                }
            }
        }
    }
    

    
    
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchLineReportsFromParse("RD")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getStationList", name: "reachabilityChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "annotateMapLocations", name: "receivedStationListFromServer", object: nil)
        dataManager.getStationListFromServer()
        dataManager.fetchIssuesFromParse()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLocationMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

