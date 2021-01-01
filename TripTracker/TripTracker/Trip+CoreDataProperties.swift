//
//  Trip+CoreDataProperties.swift
//  PA7
//
//  Created by Makoto Kewish on 11/17/20.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var destinationName: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var imageFileName: String?

}

extension Trip : Identifiable {

}
