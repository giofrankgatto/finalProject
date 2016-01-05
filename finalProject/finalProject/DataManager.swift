//
//  DataManager.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse

class DataManager {
    
    static let sharedInstance = DataManager()
    
    //MARK: - Properties

    var baseURLString = "api.wmata.com"
    let apiKey = "44e1abafef1145eebc44b74164f4125d"
    var stationsArray = [Stations]()
    var trainsArray = [Trains]()
    var issuesArray = [PFObject]()
    var reportedIssuesArray = [PFObject]()
    var reportedLineIssuesArray = [PFObject]()
    
    //MARK: - Get Data Methods
    
    func getTrainWithName(locationName: String) -> Trains {
        let selectedStation = trainsArray.filter({$0.locationName == locationName})
        return selectedStation[0]
    }
    
    func parseStationData (data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            trainsArray.removeAll()
            let tempArray = jsonResult.objectForKey("Trains") as! NSArray
            for train in tempArray {
                let currentTrainInfo = Trains()
                currentTrainInfo.destinationName = String(train.objectForKey("DestinationName")!)
                currentTrainInfo.lineColor = String(train.objectForKey("Line")!)
                currentTrainInfo.locationName = String(train.objectForKey("LocationName")!)
                currentTrainInfo.minutesToArrival = String(train.objectForKey("Min")!)
                trainsArray.append(currentTrainInfo)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedTrainDataFromServer", object: nil))
            }
        } catch {
        }
    }
    
    
    
    func getTrainsFromServer(stationCode: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        let url = NSURL(string: "http://\(baseURLString)/StationPrediction.svc/json/GetPrediction/\(stationCode)")
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        urlRequest.HTTPMethod = "GET"
        urlRequest.addValue(apiKey, forHTTPHeaderField: "api_key")
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            if data != nil {
                guard let httpResponse = response as? NSHTTPURLResponse else {
                    return
                }
                if httpResponse.statusCode == 200 {
                    self.parseStationData(data!)
                } else {
                }
            } else {
            }
        }
        task.resume()
    }

    
    
    //MARK: - Station List Methods
    
    func getStationWithName(stationName: String) -> Stations {
        let selectedStation = stationsArray.filter({$0.stationName == stationName})
        return selectedStation[0]
    }
    
    func parseStationListData (data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            stationsArray.removeAll()
            let stationListArray = jsonResult.objectForKey("Stations") as! [NSDictionary]
            for station in stationListArray {
                let stationListInfo = Stations ()
                stationListInfo.stationLat = String(station ["Lat"]!)
                stationListInfo.stationLon = String(station ["Lon"]!)
                stationListInfo.stationName = String (station ["Name"]!)
                stationListInfo.stationCode = String(station["Code"]!)
                stationListInfo.stationLine1 = String(station["LineCode1"]!)
                stationListInfo.stationLine2 = String(station["LineCode2"]!)
                stationListInfo.stationLine3 = String(station["LineCode3"]!)
                stationListInfo.stationLine4 = String(station["LineCode4"]!)
                
                let stationAddress = station.objectForKey("Address") as! NSDictionary
                stationListInfo.stationStreet = String(stationAddress ["Street"]!)
                stationListInfo.stationCity = String(stationAddress ["City"]!)
                stationListInfo.stationState = String(stationAddress ["State"]!)
                stationListInfo.stationZip = String(stationAddress ["Zip"]!)
                stationsArray.append(stationListInfo)
            }
            
            
            
            
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedStationListFromServer", object: nil))
            }
        } catch {
        }
    }
    
    
    
    func getStationListFromServer() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        let url = NSURL(string: "http://\(baseURLString)/Rail.svc/json/jStations")
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        urlRequest.HTTPMethod = "GET"
        urlRequest.addValue(apiKey, forHTTPHeaderField: "api_key")
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            if data != nil {
                guard let httpResponse = response as? NSHTTPURLResponse else {
                    return
                }
                if httpResponse.statusCode == 200 {
                    self.parseStationListData(data!)
                } else {
                }
            } else {
            }
        }
        task.resume()
    }
    
    
    //MARK: - Issue Fetch Method
    
    func fetchIssuesFromParse() {
        let fetchIssues = PFQuery(className: "ReportIssue")
        fetchIssues.orderByAscending("issueName")
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.issuesArray = objects!
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedIssueDataFromServer", object: nil))
                }
            } else {
            }
        }
        
    }
    
    func fetchReportedIssuesFromParse(selectedStation: String) {
        let fetchIssues = PFQuery(className: "IssueReported")
        fetchIssues.whereKey("Station", equalTo: selectedStation)
        fetchIssues.orderByAscending("Issue")
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.reportedIssuesArray = objects!
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedReportedIssueDataFromServer", object: nil))
                }
            } else {
            }
        }
        
    }
    
    func fetchLineReportsFromParse(selectedLine: String) {
        let fetchIssues = PFQuery(className: "IssueReported")
        fetchIssues.whereKey("Line", matchesRegex: selectedLine)
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.reportedLineIssuesArray = objects!
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedLineIssueDataFromServer", object: nil))
                    
                }
            }
        }
    }
    
  
    
    
    
}
