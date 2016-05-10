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
        
        if serverAvailable {
        } else {
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "reachabilityChanged", object: nil))
    }
    
    override init() {
        super.init()
        let dataManager = DataManager.sharedInstance
        serverReach = Reachability(hostName: dataManager.baseURLString)
        serverReach?.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
        
    }
    

}
