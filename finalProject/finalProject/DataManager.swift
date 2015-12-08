//
//  DataManager.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit
import Parse

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    //MARK: - Properties

    var baseURLString = "api.wmata.com"
    let apiKey = "44e1abafef1145eebc44b74164f4125d"
    var stationsArray = [Stations]()
    var trainsArray = [Trains]()
    var issuesArray = [PFObject]()
    var reportedIssuesArray = [PFObject]()
    
    //MARK: - Get Data Methods
    
    func getTrainWithName(locationName: String) -> Trains {
        let selectedStation = trainsArray.filter({$0.locationName == locationName})
        return selectedStation[0]
    }
    
    func parseStationData (data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            print("JSON:\(jsonResult)")
            trainsArray.removeAll()
            let tempArray = jsonResult.objectForKey("Trains") as! NSArray
            for train in tempArray {
                let currentTrainInfo = Trains()
//                stationInfo.numberOfCars = String(train.objectForKey("Car")!)
                currentTrainInfo.destinationName = String(train.objectForKey("DestinationName")!)
                currentTrainInfo.lineColor = String(train.objectForKey("Line")!)
                currentTrainInfo.locationName = String(train.objectForKey("LocationName")!)
                currentTrainInfo.minutesToArrival = String(train.objectForKey("Min")!)
                print("Station Name: \(currentTrainInfo.locationName)")
                trainsArray.append(currentTrainInfo)
            }
            print("Train Count \(trainsArray.count)")
            
            
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedTrainDataFromServer", object: nil))
            }
        } catch {
            print ("JSON Parsing Error")
        }
    }
    
    
    
    func getTrainsFromServer(stationCode: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
//        let url = NSURL(string: "http://\(baseURLString)/StationPrediction.svc/json/GetPrediction/All")
        print("Would be: \("http://\(baseURLString)/StationPrediction.svc/json/GetPrediction/\(stationCode)")")
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
                    print("Got Data")
                    self.parseStationData(data!)
                } else {
                    print("Got Other Status Code: \(httpResponse.statusCode)")
                }
            } else {
                print("No Data")
            }
        }
        task.resume()
    }
//    
//    func convertCoordinateToString(coordinate: CLLocationCoordinate2D) -> String {
//        print("\(coordinate.latitude),\(coordinate.longitude)")
//        return "\(coordinate.latitude),\(coordinate.longitude)"
//    }
//    
//    func geocodeAddress(address: String) {
//        let geocoder = CLGeocoder()
//        
//        geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
//            if let firstPlacemark = placemarks?.first {
//                let coordinates = firstPlacemark.location!.coordinate
//                
//                self.getDataFromServer(self.convertCoordinateToString(coordinates))
//                
//            }
//        }
//    }
    
    
    
    //MARK: - Station List Methods
    
    func getStationWithName(stationName: String) -> Stations {
        let selectedStation = stationsArray.filter({$0.stationName == stationName})
        return selectedStation[0]
    }
    
    func parseStationListData (data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            print("JSON:\(jsonResult)")
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
                
                print("Station Name: \(stationListInfo.stationName)")

                let stationAddress = station.objectForKey("Address") as! NSDictionary
                stationListInfo.stationStreet = String(stationAddress ["Street"]!)
                stationListInfo.stationCity = String(stationAddress ["City"]!)
                stationListInfo.stationState = String(stationAddress ["State"]!)
                stationListInfo.stationZip = String(stationAddress ["Zip"]!)
                print("Station Street: \(stationListInfo.stationStreet)")
                stationsArray.append(stationListInfo)
            }
            print("Count \(stationsArray.count)")
            
            
            
            
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedStationListFromServer", object: nil))
            }
        } catch {
            print ("JSON Parsing Error")
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
                    print("Got Station List Data")
                    self.parseStationListData(data!)
                } else {
                    print("Got Other Status Code: \(httpResponse.statusCode)")
                }
            } else {
                print("No Data")
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
                print("Got Classes Data")
                self.issuesArray = objects!
                //                print("Issues Array: \(self.issuesArray)")
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedIssueDataFromServer", object: nil))
                }
            } else {
                print("No Issues")
            }
        }
        
    }
    
    func fetchReportedIssuesFromParse(selectedStation: String) {
        let fetchIssues = PFQuery(className: "IssueReported")
        fetchIssues.whereKey("Station", equalTo: selectedStation)
        fetchIssues.orderByAscending("Issue")
        fetchIssues.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print("Got Classes Data")
                self.reportedIssuesArray = objects!
                //                print("Issues Array: \(self.issuesArray)")
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedReportedIssueDataFromServer", object: nil))
                }
            } else {
                print("No Issues")
            }
        }
        
    }
    
    
    
    
}
