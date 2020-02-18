//
//  DemoPresenter.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 29.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import Then
import RxSwift
import RxCocoa

class DemoPresenterImpl {
    private(set) var forecast: Forecast
    private let forecastVerificationService: ForecastVerificationService
    private lazy var updateOutcomeRelay = BehaviorRelay<Void>(value: ())

    init(forecast: Forecast, forecastVerificationService: ForecastVerificationService) {
        self.forecast = forecast
        self.forecastVerificationService = forecastVerificationService
    }

    lazy var viewModel = DemoViewModel().with {
        $0.title = .just(forecast.title ?? "")
        $0.description = .just(forecast.eventDescription)

        let outcome = updateOutcomeRelay.asDriver()
            .map { [weak self] _ in self?.forecast.outcome }
        $0.outcomeMode = outcome
            .map { $0 == nil ? .twoButtons : .string }
        $0.outcomeText = outcome.asObservable()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .map { $0 ? "Happened" : "Not Happened "}
        typealias Button = DemoViewModel.OutcomeButton
        $0.leftOutcomeButton = Button().with {
            $0.title = .just("Happened")
            $0.handler = .just { [weak self] in
                self?.verifyForecast(outcome: true)
            }
        }
        $0.rightOutcomeButton = Button().with {
            $0.title = .just("Not Happened")
            $0.handler = .just { [weak self] in
                self?.verifyForecast(outcome: false)
            }
        }
    }

    fileprivate func verifyForecast(outcome: Bool) {
        guard !self.forecast.verified else { return }
        forecast = forecastVerificationService.verifyForecast(forecast, outcome: outcome)
        updateOutcomeRelay.accept(())
    }
}
