//
//  ManagedForecast.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 2019-10-23.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import CoreData

final class ManagedForecast: NSManagedObject, Forecast {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedForecast> {
        return NSFetchRequest<ManagedForecast>(entityName: "Forecast")
    }

    @NSManaged public var id: Id
    @NSManaged public var name: String?
    @NSManaged public var eventDescription: String
    @NSManaged public var probabilityEstimate: Double
    @NSManaged public var isEventDesired: Bool
    @NSManaged public var creationDate: Date
    @NSManaged public var deadline: Date?
    @NSManaged public var outcomeNum: NSNumber?
    var outcome: Bool? {
        get { return outcomeNum.map { $0.boolValue } }
        set { outcomeNum = newValue.map { NSNumber(value: $0 )} }
    }
    @NSManaged public var verificationDate: Date?
}
