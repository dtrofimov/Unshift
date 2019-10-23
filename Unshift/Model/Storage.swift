//
//  Storage.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 2019-10-22.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit
import CoreData

protocol Storage {
    var container: NSPersistentContainer { get }
}

protocol StorageResolver {
    func resolveStorage() -> Storage
}

class StorageImpl: Storage {
    let container = NSPersistentContainer(name: "unshift", managedObjectModel: .shared)

    static func makeAndLoad(completion: @escaping (StorageImpl) -> ()) {
        let storage = StorageImpl()
        storage.container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completion(storage)
        }
    }
}
