//
//  DataManager.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    //MARK: - Properties

    var baseURLString = "api.wmata.com"
    let apiKey = "44e1abafef1145eebc44b74164f4125d"
    var stationsArray = [StationVariables]()
    
    //MARK: - Get Data Methods
    
    func parseStationData (data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            print("JSON:\(jsonResult)")
            let trainsArray = jsonResult.objectForKey("Trains") as! NSArray
            for train in trainsArray {
                let stationInfo = StationVariables ()
//                stationInfo.numberOfCars = String(train.objectForKey("Car")!)
                stationInfo.destinationName = String(train.objectForKey("DestinationName")!)
                stationInfo.lineColor = String(train.objectForKey("Line")!)
                stationInfo.locationName = String(train.objectForKey("LocationName")!)
                stationInfo.minutesToArrival = String(train.objectForKey("Min")!)
                print("Station Name: \(stationInfo.locationName)")
                stationsArray.append(stationInfo)
            }
            print("Count \(stationsArray.count)")
            
            
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedDataFromServer", object: nil))
            }
        } catch {
            print ("JSON Parsing Error")
        }
    }
    
    
    
    func getDataFromServer() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        let url = NSURL(string: "http://\(baseURLString)/StationPrediction.svc/json/GetPrediction/All")
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        urlRequest.HTTPMethod = "GET"
//        [_request setHTTPBody:[@"{body}" dataUsingEncoding:NSUTF8StringEncoding]];
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

    
    
    
}
