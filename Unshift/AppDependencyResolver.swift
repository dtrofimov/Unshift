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
    private(set) lazy var dateService: DateService = DateServiceImpl()
    private(set) lazy var forecastsService: ForecastsService = ForecastsServiceImpl(storage: storage)
    private(set) lazy var forecastVerificationService: ForecastVerificationService = ForecastVerificationServiceImpl(forecastsService: forecastsService, dateService: dateService)

    static func make(completion: @escaping (AppDependencyResolver) -> ()) {
        let resolver = AppDependencyResolver()
        StorageImpl.makeAndLoad { storage in
            resolver.storage = storage
            completion(resolver)
        }
    }
}

extension AppDependencyResolver: DemoScreenResolver {
    func resolveDemoScreen(forecast: Forecast) -> UIViewController {
        let vc = DemoViewController()
        let presenter = DemoPresenterImpl(forecast: forecast, forecastVerificationService: forecastVerificationService)
        vc.model = presenter.viewModel
        vc.attachForLifetime(presenter)
        return vc
    }
}
