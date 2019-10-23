//
//  Model.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 2019-10-22.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import CoreData

extension NSManagedObjectModel {
    static let shared = NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "Model", withExtension: "momd")!)!
}
