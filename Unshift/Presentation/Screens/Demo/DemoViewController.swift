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
                    _ = model.title.asObservable()
                        .takeUntil($0.rx.deallocated)
                        .map { $0 }
                        .bind(to: $0.rx.text)
                })

                // description
                $0.addArrangedSubview(UILabel().then {
                    _ = model.description.asObservable()
                        .takeUntil($0.rx.deallocated)
                        .map { $0 }
                        .bind(to: $0.rx.text)
                })

                // outcome
                $0.addArrangedSubview(UIView().then { container in
                    weak var content: UIView! {
                        didSet {
                            guard oldValue !== content else { return }
                            oldValue?.removeFromSuperview()
                            container.addSubviewAndLayoutToEdges(content)
                        }
                    }

                    _ = model.outcomeMode.asObservable()
                        .takeUntil(container.rx.deallocated)
                        .distinctUntilChanged()
                        .bind {
                            switch $0 {
                            case .string:
                                content = UILabel().then {
                                    _ = model.outcomeText.asObservable()
                                        .takeUntil($0.rx.deallocated)
                                        .map { $0 }
                                        .bind(to: $0.rx.text)
                                }
                            case .twoButtons:
                                content = UIStackView().then {
                                    for model in [model.leftOutcomeButton, model.rightOutcomeButton] {
                                        $0.addArrangedSubview(UIButton(type: .system).then {
                                            _ = model.title.asObservable()
                                                .takeUntil($0.rx.deallocated)
                                                .map { $0 }
                                                .bind(to: $0.rx.title())
                                            _ = $0.rx.tap
                                                .withLatestFrom(model.handler)
                                                .bind {
                                                    $0?()
                                            }
                                        })
                                    }
                                }
                            }
                    }
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
