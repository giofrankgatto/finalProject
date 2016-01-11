//
//  LineIssuesViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 12/8/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse


class LineIssuesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var currentLine : String!
    let dataManager = DataManager.sharedInstance
    
    @IBOutlet weak var          lineIssuesCollectionView            :UICollectionView!
    @IBOutlet weak var          noIssuesLabel                       :UILabel!
    
    
    
    func fetchLineReportsFromParse(selectedLine: String) {
        let fetchIssues = PFQuery(className: "IssueReported")
        fetchIssues.whereKey("Line", matchesRegex: selectedLine)
        
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                
            }
        }
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.reportedLineIssuesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LineIssuesCollectionViewCell
        
       
        
        let currentIssues = dataManager.reportedLineIssuesArray[indexPath.row]
        
        
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let stringDate = formatter.stringFromDate(currentIssues.createdAt!)
        cell.timeReportedLabel.text = stringDate
        
        
        
        cell.stationNameLabel.text = (currentIssues["Station"] as! String)
        cell.issueNameLabel.text = (currentIssues["Issue"] as! String)
        
        
        
        
        let userImageFile = currentIssues["imageFile"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.issueImageView.image = UIImage(data:imageData)
                
                }
            }
            
        }
        
            return cell
    }
    
    func gotLineIssuesData () {
        if dataManager.reportedLineIssuesArray.count == 0 {
            lineIssuesCollectionView.hidden = true
        } else {
            lineIssuesCollectionView.hidden = false
            lineIssuesCollectionView.reloadData()
        }
    }
    
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        if currentLine == "RD" {
            self.title = "Red Line"
        } else if currentLine == "BL" {
            self.title = "Blue Line"
        } else if currentLine == "GR" {
            self.title = "Green Line"
        } else if currentLine == "OR" {
            self.title = "Orange Line"
        } else if currentLine == "SV" {
            self.title = "Silver Line"
        } else if currentLine == "YL" {
            self.title = "Yellow Line"
        }
        
        
        if dataManager.reportedLineIssuesArray.count == 0 {
            noIssuesLabel.text = "There are no current reported issues for this line!"
            noIssuesLabel.textColor = UIColor.blackColor()
        }
        
        dataManager.fetchLineReportsFromParse(currentLine)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLineIssuesData", name: "receivedLineIssueDataFromServer", object: nil)
        
        fetchLineReportsFromParse(currentLine)
        lineIssuesCollectionView.reloadData()
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    

  
}
