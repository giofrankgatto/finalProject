//
//  NetworkManager.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
    
    var serverReach: Reachability?
    var serverAvailable = false
    
    func reachabilityChanged(note: NSNotification) {
        let reach = note.object as! Reachability
        serverAvailable = !(reach.currentReachabilityStatus().rawValue == NotReachable.rawValue)
        //is reachability status NOT not reachable
        
        if serverAvailable {
            print("Changed: Server Available")
        } else {
            print("Changed: Server NOT Available")
        }
    }
    
    override init() {
        super.init()
        //anytime you do an override, you need to call a super
        print("Starting Network Manager")
        let dataManager = DataManager.sharedInstance
        //this brings the property from DM over
        serverReach = Reachability(hostName: dataManager.baseURLString)
        //set host name
        serverReach?.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
        //everytime reachability changes it sends us a notification
        
    }
    

}
