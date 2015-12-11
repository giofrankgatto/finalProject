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

//        if let reportIssueImage = (currentIssues["imageFile"] as? PFFile)  {
//            reportIssueImage.getDataInBackgroundWithBlock {
//                (imageData: NSData?, error: NSError?) -> Void in
//                if error == nil {
//                    if let _ = imageData {
//                        cell.issueImageView = UIImageView()
//                    }
//                }
//            }
            return cell
    }
    
    func gotLineIssuesData () {
        lineIssuesCollectionView.reloadData()
    }
    
    
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
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
