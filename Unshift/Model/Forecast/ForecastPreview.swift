//
//  ForecastPreview.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 31.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

struct ForecastPreview {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return formatter
    }()

    static let forecast1 = PlainForecast(id: UUID(uuidString: "816e4ae4-f72b-11e9-8f0b-362b9e155667")!,
                                         title: nil,
                                         eventDescription: "Я сдам дифуры на отл. 2019-05-28.",
                                         probabilityEstimate: 0.7,
                                         isEventDesired: true,
                                         creationDate: dateFormatter.date(from: "2019-05-25T16:34:00+03")!,
                                         deadline: dateFormatter.date(from: "2019-05-29T00:00:00+03")!,
                                         outcome: nil,
                                         verificationDate: nil)
}
