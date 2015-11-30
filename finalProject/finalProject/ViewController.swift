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

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
     //MARK: - Properties
    
    let networkManager = NetworkManager.sharedInstance
    let dataManager = DataManager.sharedInstance
    
    
    
   
    
    
    @IBOutlet   var         loginButton             :UIBarButtonItem!
    
    
    
    
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
            loginButton.title = "Log In"
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
    

    
    
    
    
    //MARK: - Get Data Methods
    
    @IBAction func getDataSearchButton(sender: UIButton) {
        if networkManager.serverAvailable {
            print ("server available")
            dataManager.getDataFromServer()
        } else {
            print("Server Not Available")
        }
    }

    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

