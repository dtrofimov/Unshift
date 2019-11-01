//
//  DateService.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 31.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

protocol DateService {
    var currentDate: Date { get }
}

class DateServiceImpl: DateService {
    var currentDate: Date { Date() }
}
