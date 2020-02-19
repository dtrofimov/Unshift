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

class DemoPresenterImpl: DemoViewModel {
    private(set) var forecast: Forecast
    private let forecastVerificationService: ForecastVerificationService
    private lazy var updateOutcome = BehaviorRelay<Void>(value: ())

    init(forecast: Forecast, forecastVerificationService: ForecastVerificationService) {
        self.forecast = forecast
        self.forecastVerificationService = forecastVerificationService
    }

    fileprivate func verifyForecast(outcome: Bool) {
        guard !self.forecast.verified else { return }
        forecast = forecastVerificationService.verifyForecast(forecast, outcome: outcome)
        updateOutcome.accept(())
    }

    // MARK: - DemoViewModel implementation

    lazy var title: Driver<String> = .just(forecast.title ?? "")
    lazy var description: Driver<String> = .just(forecast.eventDescription)

    private lazy var outcome: Driver<Bool?> = updateOutcome.asDriver()
        .map { [weak self] _ in self?.forecast.outcome }
    lazy var outcomeMode: Driver<OutcomeMode> = outcome
        .map { $0 == nil ? .twoButtons : .string }
    lazy var outcomeText: Driver<String?> = outcome.asObservable()
        .compactMap { $0 }
        .asDriver(onErrorDriveWith: .empty())
        .map { $0 ? "Happened" : "Not Happened "}

    func outcomeButton(outcome: Bool) -> OutcomeButtonModel {
        struct Model: OutcomeButtonModel {
            let title: Driver<String>
            let handler: Driver<(() -> ())?>
        }
        return Model(
            title: .just(outcome ? "Happened" : "Not Happened"),
            handler: .just { [weak self] in
                self?.verifyForecast(outcome: outcome)
            })
    }
    lazy var leftOutcomeButton: OutcomeButtonModel = outcomeButton(outcome: true)
    lazy var rightOutcomeButton: OutcomeButtonModel = outcomeButton(outcome: false)

}
