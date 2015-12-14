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
    
    @IBOutlet weak var          trainsTableView     :UITableView!
    @IBOutlet weak var          issuesTableView     :UITableView!
    @IBOutlet weak var          stationName         :UILabel!
    @IBOutlet weak var          trainLocation       :UILabel!
    var currentStation :Stations!
    var currentTrain :Trains!
    
    let dataManager = DataManager.sharedInstance
    
    
    //MARK: Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == issuesTableView {
            return dataManager.reportedIssuesArray.count
        } else if tableView == trainsTableView {
            return dataManager.trainsArray.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == issuesTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StationTableViewCell
            let currentIssue = dataManager.reportedIssuesArray[indexPath.row]
            cell.issueNameLabel!.text = (currentIssue["Issue"] as! String)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh:ss a"
            let stringDate = formatter.stringFromDate(currentIssue.createdAt!)
            cell.timePostedLabel.text = stringDate
            
            
            let userImageFile = currentIssue["imageFile"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.issueImage.image = UIImage(data:imageData)
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TrainTableViewCell
            let nextTrain = dataManager.trainsArray[indexPath.row]
            //            cell.locationName!.text = (nextTrain.locationName as String)
            cell.destinationName!.text = (nextTrain.destinationName as String)
            cell.minutesToArrival!.text = (nextTrain.minutesToArrival as String)
            cell.lineColor!.text = (nextTrain.lineColor as String)
            return cell
            
        }
    }
    
    
    
    func gotNewIssues() {
        issuesTableView.reloadData()
    }
    
    func gotTrains() {
        trainsTableView.reloadData()
    }
    
   //MARK: - API Data Label Methods
    
    
    
    
        
    
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentStation.stationName)
        self.title = currentStation.stationName
       // stationName.text = currentStation.stationName
        
        dataManager.getTrainsFromServer(currentStation.stationCode)
        dataManager.fetchReportedIssuesFromParse(currentStation.stationName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotNewIssues", name: "receivedReportedIssueDataFromServer", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotTrains", name: "receivedTrainDataFromServer", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
