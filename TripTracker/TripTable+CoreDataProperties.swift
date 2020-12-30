//
//  TripTable+CoreDataProperties.swift
//  PA6
//
//  Created by Makoto Kewish on 11/17/20.
//
//

import Foundation
import CoreData


extension TripTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripTable> {
        return NSFetchRequest<TripTable>(entityName: "TripTable")
    }

    @NSManaged public var destinationName: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var imageFileName: String?

}

extension TripTable : Identifiable {

}
