//
//  AppDependencyResolver.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 2019-10-23.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit

class AppDependencyResolver {
    private(set) var storage: Storage!

    static func make(completion: @escaping (AppDependencyResolver) -> ()) {
        let resolver = AppDependencyResolver()
        StorageImpl.makeAndLoad { storage in
            resolver.storage = storage
            completion(resolver)
        }
    }
}

extension AppDependencyResolver: StorageResolver {
    func resolveStorage() -> Storage {
        return storage
    }
}
