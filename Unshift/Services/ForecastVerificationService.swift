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

class ForecastVerificationServiceImpl: ForecastVerificationService {
    let forecastsService: ForecastsService
    let dateService: DateService

    init(forecastsService: ForecastsService, dateService: DateService) {
        self.forecastsService = forecastsService
        self.dateService = dateService
    }

    func verifyForecast(_ forecast: Forecast, outcome: Bool) -> Forecast {
        var verified = PlainForecast(forecast: forecast)
        verified.outcome = outcome
        verified.verificationDate = dateService.currentDate
        forecastsService.upsertForecast(verified)
        return verified
    }
}
