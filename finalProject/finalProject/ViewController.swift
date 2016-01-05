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


class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
     //MARK: - Properties
    
    let networkManager = NetworkManager.sharedInstance
    let dataManager = DataManager.sharedInstance
    var selectedStationName :String!
    var selectedTrainName :String!
    var selectedLineName :String!
    var senderLine : String!

    
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
    
    func updateLoginButtonDisplay() {
        if let _ = PFUser.currentUser() {
            loginButton.title = "Logout"
        } else {
            loginButton.title = "Login"
        }
    }
    
    @IBAction func loginButtonPressed (sender: UIBarButtonItem) {
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
    

    
    
    @IBAction func newReportButtonPressed (sender: UIBarButtonItem) {
        if (PFUser.currentUser() != nil) {
            performSegueWithIdentifier("segueNewReport", sender: self)
        } else {
            let alert = UIAlertController(title: "You are not logged in!", message: "In order to report an issue, you must be logged in.  Please do so now!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
                self.loginButtonPressed(self.loginButton)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
   
    
    //MARK: - MapKit Methods
    
    var locationManager: CLLocationManager = CLLocationManager()
   
    
    func centerMapOnLocation(map:MKMapView) {
        let currentLocation = locationManager.location!.coordinate
        let center = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        map.setRegion(region, animated: true)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        centerMapOnLocation(stationMapView)
    }
    
    func turnOnLocationMonitoring() {
       
        locationManager.startUpdatingLocation()
        stationMapView.showsUserLocation = true
    }
    
    func setupLocationMonitoring () {
        locationManager = CLLocationManager ()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                turnOnLocationMonitoring()
            case .Denied, .Restricted, .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            }
            
        } else {
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
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if pin == nil {
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pin!.canShowCallout = true
                pin!.image = UIImage(named: "metropin")
                pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            pin!.annotation = annotation
            return pin
        }
    }
    
  
    
    //MARK: - Segue Methods
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.selectedStationName = view.annotation!.title!
        self.selectedTrainName = view.annotation!.title!
        self.performSegueWithIdentifier("segueStationDetail", sender: self)
    }
    
    @IBAction func lineButtonPressed(button: UIButton) {
        switch button.tag {
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
        break
        }
        performSegueWithIdentifier("segueLineIssue", sender: self)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueStationDetail" {
            let destController = segue.destinationViewController as! StationInfoViewController
            destController.currentStation = dataManager.getStationWithName(selectedStationName)
        } else if segue.identifier == "segueLineIssue" {
            let destController = segue.destinationViewController as! LineIssuesViewController
            destController.currentLine = senderLine
        }
    }
   
    
    

    //MARK: - Get Data Methods

    
    func getStationList() {
        if networkManager.serverAvailable {
            dataManager.getStationListFromServer()
        } else {
        }
    }

    


    
    func fetchLineReportsFromParse(selectedLine: String) {
        let fetchIssues = PFQuery(className: "IssueReported")
        fetchIssues.whereKey("Line", matchesRegex: selectedLine)
        
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                
            }
        }
    }
    

    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getStationList", name: "reachabilityChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "annotateMapLocations", name: "receivedStationListFromServer", object: nil)
        dataManager.fetchIssuesFromParse()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLocationMonitoring()
        updateLoginButtonDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

