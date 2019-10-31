//
//  DemoPresenter.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 29.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation

protocol DemoPresenter {
    func displayForecast(_ forecast: Forecast)
}

class DemoPresenterImpl: DemoPresenter {
    private(set) var forecast: Forecast!

    var view: DemoView

    init(view: DemoView) {
        self.view = view
    }

    func displayForecast(_ forecast: Forecast) {
        self.forecast = forecast
        view.updateOutcomeMode()
    }
}

extension DemoPresenterImpl: DemoViewDataSource {
    func showTopContent(titleLabel: Label, descriptionLabel: Label) {
        titleLabel.text = forecast.title ?? ""
        descriptionLabel.text = forecast.eventDescription
    }

    var viewOutcomeMode: DemoViewOutcomeMode {
        forecast.outcome == nil ? .showButtonsToResolve : .showOutcome
    }

    func showOutcome(label: Label) {
        label.text = forecast.outcome == true ? "Happened" : "Not happened"
    }

    func showButtonsToResolve(happenedButton: Button, notHappenedButton: Button) {
        happenedButton.title = "Happened"
        happenedButton.tapHandler = {
            NSLog("Happened")
        }
        notHappenedButton.title = "Not Happened"
        notHappenedButton.tapHandler = {
            NSLog("Not happened")
        }
    }
}
