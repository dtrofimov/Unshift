//
//  PlainForecast.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 2019-10-23.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

struct PlainForecast: Forecast, Equatable, Hashable {
    var id: Id
    var name: String?
    var eventDescription: String
    var probabilityEstimate: Double
    var isEventDesired: Bool
    var creationDate: Date
    var deadline: Date?
    var outcome: Bool?
    var verificationDate: Date?
}

extension PlainForecast {
    init(forecast: Forecast) {
        let orig = forecast
        self = PlainForecast(id: orig.id,
                             name: orig.name,
                             eventDescription: orig.eventDescription,
                             probabilityEstimate: orig.probabilityEstimate,
                             isEventDesired: orig.isEventDesired,
                             creationDate: orig.creationDate,
                             deadline: orig.deadline,
                             outcome: orig.outcome,
                             verificationDate: orig.verificationDate)
    }
}
