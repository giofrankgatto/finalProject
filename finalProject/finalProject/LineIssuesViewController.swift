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
                print(objects)
                print ("Got Line Data")
                
            }
        }
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.reportedLineIssuesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! LineIssuesCollectionViewCell
        
       
        
        let currentIssues = dataManager.reportedLineIssuesArray[indexPath.row]
        
        
        
        cell.stationNameLabel.text = (currentIssues["Station"] as! String)
        cell.issueNameLabel.text = (currentIssues["Issue"] as! String)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:ss a"
        let stringDate = formatter.stringFromDate(currentIssues.createdAt!)
        cell.timeReportedLabel.text = stringDate
        
        
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
        lineIssuesCollectionView.reloadData()
    }
    
    
    func noDataToShow () {
        if dataManager.reportedLineIssuesArray.count == 0 {
            self.noIssuesLabel.text = "There are no current reports for this line!"
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
        
        dataManager.fetchLineReportsFromParse(currentLine)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLineIssuesData", name: "receivedLineIssueDataFromServer", object: nil)
        
        fetchLineReportsFromParse(currentLine)
        print("RLIACount \(dataManager.reportedLineIssuesArray.count)")
        lineIssuesCollectionView.reloadData()

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    

  
}
