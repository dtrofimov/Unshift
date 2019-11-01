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
    private(set) lazy var forecastsService: ForecastsService = ForecastsServiceImpl(resolver: self)
    private(set) lazy var forecastVerificationService: ForecastVerificationService = ForecastVerificationServiceImpl(resolver: self)

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

extension AppDependencyResolver: ForecastsServiceResolver {
    func resolveForecastsService() -> ForecastsService {
        return forecastsService
    }
}

extension AppDependencyResolver: CurrentDateResolver {
    func resolveCurrentDate() -> Date {
        return Date()
    }
}

extension AppDependencyResolver: ForecastVerificationServiceResolver {
    func resolveForecastVerificationService() -> ForecastVerificationService {
        return ForecastVerificationServiceImpl(resolver: self)
    }
}

extension AppDependencyResolver: DemoScreenResolver {
    func resolveDemoScreen() -> UIViewController {
        let vc = DemoViewController()
        let presenter = DemoPresenterImpl(resolver: self, view: vc, forecast: ForecastPreview.forecast1)
        vc.dataSource = presenter
        vc.attachForLifetime(presenter)
        return vc
    }
}
