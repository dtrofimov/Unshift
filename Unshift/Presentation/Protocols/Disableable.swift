//
//  Disableable.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 10.01.2020.
//  Copyright © 2020 Dmitrii Trofimov. All rights reserved.
//

import Foundation

protocol Disableable: class {
    var isEnabled: Bool { get set }
}
