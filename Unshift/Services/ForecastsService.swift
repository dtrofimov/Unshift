//
//  ForecastsService.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 24.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import CoreData

protocol ForecastsService {
    func getForecasts() -> [Forecast]
    func upsertForecast(_ forecast: Forecast)
}

protocol ForecastsServiceResolver {
    func resolveForecastsService() -> ForecastsService
}

class ForecastsServiceImpl: ForecastsService {
    typealias Resolver = StorageResolver

    private let resolver: Resolver
    private lazy var storage: Storage = resolver.resolveStorage()
    private var viewContext: NSManagedObjectContext { storage.container.viewContext }

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func getForecasts() -> [Forecast] {
        return viewContext.performAndWait {
            return (try? ManagedForecast.safeFetchRequest.execute()) ?? []
        }
    }

    private func unsafeForecastById(_ id: UUID) -> ManagedForecast? {
        let request = ManagedForecast.safeFetchRequest
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        request.fetchLimit = 1
        return try? request.execute().first
    }

    func upsertForecast(_ forecast: Forecast) {
        let context = viewContext
        context.performAndWait {
            let dest = unsafeForecastById(forecast.id) ?? ManagedForecast(context: context)
            dest.clone(from: forecast)
            try! context.saveIfHasChanges()
        }
    }
}
