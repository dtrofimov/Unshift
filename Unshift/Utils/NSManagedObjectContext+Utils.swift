//
//  NSManagedObjectContext+Utils.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 25.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import CoreData

// https://oleb.net/blog/2018/02/performandwait/
extension NSManagedObjectContext {
    func performAndWait<T>(_ block: () -> T) -> T {
        var result: T? = nil
        // Call the framework version
        performAndWait {
            result = block()
        }
        return result!
    }
}

extension NSManagedObjectContext {
    func saveIfHasChanges() throws {
        if hasChanges {
            try save()
        }
    }
}
