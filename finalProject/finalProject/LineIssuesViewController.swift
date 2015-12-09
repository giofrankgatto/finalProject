//
//  LineIssuesViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 12/8/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse


class LineIssuesViewController: UIViewController {
    
    var currentLine : String!
    
    
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
    

    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLineReportsFromParse(currentLine)
        

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    

  
}
