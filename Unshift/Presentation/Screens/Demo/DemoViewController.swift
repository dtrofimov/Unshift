//
//  DemoViewController.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 25.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Then

enum DemoViewOutcomeMode {
    case string
    case twoButtons
}

protocol DemoViewOutcomeButtonModel {
    var title: Driver<String> { get }
    var handler: Driver<(() -> ())?> { get }
}

protocol DemoViewModel {
    typealias OutcomeMode = DemoViewOutcomeMode
    typealias OutcomeButtonModel = DemoViewOutcomeButtonModel

    var title: Driver<String> { get }
    var description: Driver<String> { get }
    var outcomeMode: Driver<OutcomeMode> { get }
    var outcomeText: Driver<String?> { get }
    var leftOutcomeButton: OutcomeButtonModel { get }
    var rightOutcomeButton: OutcomeButtonModel { get }
}

class DemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    typealias Model = DemoViewModel
    var model: Model!

    func setupSubviews() {
        let model = self.model!
        view.backgroundColor = .white
        view.addSubviewAndLayoutToEdges(UIScrollView().then {
            $0.addSubviewAndLayoutToEdges(UIStackView().then {
                $0.axis = .vertical

                // title
                $0.addArrangedSubview(UILabel().then {
                    model.title.asObservable()
                        .map { $0 }
                        .bind(to: $0.rx.text)
                        .dispose(with: $0)
                })

                // description
                $0.addArrangedSubview(UILabel().then {
                    model.description.asObservable()
                        .map { $0 }
                        .bind(to: $0.rx.text)
                        .dispose(with: $0)
                })

                // outcome
                $0.addArrangedSubview(UIView().then { container in
                    weak var weakContainer = container
                    weak var content: UIView! {
                        didSet {
                            guard oldValue !== content else { return }
                            oldValue?.removeFromSuperview()
                            weakContainer?.addSubviewAndLayoutToEdges(content)
                        }
                    }

                    model.outcomeMode.asObservable()
                        .distinctUntilChanged()
                        .bind {
                            switch $0 {
                            case .string:
                                content = UILabel().then {
                                    model.outcomeText.asObservable()
                                        .takeUntil($0.rx.deallocated)
                                        .map { $0 }
                                        .bind(to: $0.rx.text)
                                        .dispose(with: $0)
                                }
                            case .twoButtons:
                                content = UIStackView().then {
                                    for model in [model.leftOutcomeButton, model.rightOutcomeButton] {
                                        $0.addArrangedSubview(UIButton(type: .system).then {
                                            model.title.asObservable()
                                                .map { $0 }
                                                .bind(to: $0.rx.title())
                                                .dispose(with: $0)
                                            $0.rx.tap
                                                .withLatestFrom(model.handler)
                                                .bind { $0?() }
                                                .dispose(with: $0)
                                        })
                                    }
                                }
                            }
                    }
                    .dispose(with: container)
                })
            })
        })
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct DemoViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = DemoViewController()
        vc.model = DemoPresenterImpl(forecast: ForecastPreview.forecast1, forecastVerificationService: nil!)
        return ViewControllerPreview(viewController: vc)
    }
}
#endif
