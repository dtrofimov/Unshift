//
//  ForecastVerificationService.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 01.11.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

protocol ForecastVerificationService {
    func verifyForecast(_ forecast: Forecast, outcome: Bool) -> Forecast
}

protocol ForecastVerificationServiceResolver {
    func resolveForecastVerificationService() -> ForecastVerificationService
}

class ForecastVerificationServiceImpl: ForecastVerificationService {
    typealias Resolver = ForecastsServiceResolver & CurrentDateResolver
    private let resolver: Resolver
    lazy var forecastService = resolver.resolveForecastsService()

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func verifyForecast(_ forecast: Forecast, outcome: Bool) -> Forecast {
        var verified = PlainForecast(forecast: forecast)
        verified.outcome = outcome
        verified.verificationDate = resolver.resolveCurrentDate()
        forecastService.upsertForecast(verified)
        return verified
    }
}
