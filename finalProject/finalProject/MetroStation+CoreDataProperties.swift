//
//  MetroStation+CoreDataProperties.swift
//  finalProject
//
//  Created by Giovanni Gatto on 12/2/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MetroStation {

    @NSManaged var stationName: String?
    @NSManaged var stationLine1: String?
    @NSManaged var userID: String?
    @NSManaged var dateEntered: NSDate?
    @NSManaged var dateUpdated: NSDate?
    @NSManaged var stationLine2: String?
    @NSManaged var stationLine3: String?
    @NSManaged var stationLine4: String?
    @NSManaged var stationLine5: String?
    @NSManaged var stationLat: String?
    @NSManaged var stationLon: String?

}
