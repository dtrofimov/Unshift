//
//  Forecast.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 2019-10-23.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

protocol Forecast {
    typealias Id = UUID

    // MARK: Defined on creation

    var id: Id { get }

    /// An optional forecast title.
    var title: String? { get }

    /// A description of the estimated event, formal enough to verify the outcome.
    var eventDescription: String { get }

    /// An estimated probability of the event.
    var probabilityEstimate: Double { get }

    /// A flag indicating the emotional attitude towards the estimated event (desired or avoided).
    var isEventDesired: Bool { get }

    /// A forecast creation date.
    var creationDate: Date { get }

    /// An optional date at which the outcome is expected to be known.
    var deadline: Date? { get }


    // MARK: Defined on verification

    /// A flag indicating whether the estimated event occured (true), not occured (false), or still unknown (nil).
    var outcome: Bool? { get }

    /// A forecast verification date.
    var verificationDate: Date? { get }
}

extension Forecast {
    var verified: Bool { return outcome != nil }
}
