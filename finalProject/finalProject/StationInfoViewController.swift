//
//  StationInfoViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 12/4/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse

class StationInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var          issuesTableView     :UITableView!
    @IBOutlet weak var          stationName         :UILabel!
    @IBOutlet weak var          trainLocation       :UILabel!
    var currentStation :Stations!
    var currentTrain :Trains!
    
    let dataManager = DataManager.sharedInstance
    
    
    //MARK: Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.reportedIssuesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StationTableViewCell
        let currentIssue = dataManager.reportedIssuesArray[indexPath.row]
        cell.issueNameLabel!.text = (currentIssue["Issue"] as! String)
        return cell
    }
    

    

    func gotNewIssues() {
        issuesTableView.reloadData()
    }
    
    
   //MARK: - API Data Label Methods
    
    
    
    
    
    
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentStation.stationName
        stationName.text = currentStation.stationName
        
//        trainLocation.text = currentTrain.locationName
        dataManager.getDataFromServer()
        dataManager.fetchReportedIssuesFromParse(currentStation.stationName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotNewIssues", name: "receivedReportedIssueDataFromServer", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
