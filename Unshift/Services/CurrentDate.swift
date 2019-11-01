//
//  CurrentDate.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 31.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

protocol CurrentDateResolver {
    func resolveCurrentDate() -> Date
}
