//
//  DemoPresenter.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 29.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

class DemoPresenterImpl {
    private(set) var forecast: Forecast
    private let forecastVerificationService: ForecastVerificationService

    weak var view: DemoView?

    init(view: DemoView, forecast: Forecast, forecastVerificationService: ForecastVerificationService) {
        self.view = view
        self.forecast = forecast
        self.forecastVerificationService = forecastVerificationService
    }

    fileprivate func verifyForecast(outcome: Bool) {
        forecast = forecastVerificationService.verifyForecast(forecast, outcome: outcome)
        view?.updateOutcomeMode()
    }
}

extension DemoPresenterImpl: DemoViewDataSource {
    func showTopContent(titleLabel: Label, descriptionLabel: Label) {
        titleLabel.text = forecast.title ?? ""
        descriptionLabel.text = forecast.eventDescription
    }

    var viewOutcomeMode: DemoViewOutcomeMode {
        forecast.outcome == nil ? .showButtonsToVerify : .showOutcome
    }

    func showOutcome(label: Label) {
        label.text = forecast.outcome == true ? "Happened" : "Not happened"
    }

    func showButtonsToVerify(happenedButton: Button, notHappenedButton: Button) {
        happenedButton.title = "Happened"
        happenedButton.tapHandler = { [weak self] in
            self?.verifyForecast(outcome: true)
        }
        notHappenedButton.title = "Not Happened"
        notHappenedButton.tapHandler = { [weak self] in
            self?.verifyForecast(outcome: false)
        }
    }
}
