//
//  DemoViewController.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 25.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit
import SnapKit

enum DemoViewOutcomeMode {
    case showOutcome
    case showButtonsToResolve
}

protocol DemoViewDataSource {
    func showTopContent(titleLabel: Label, descriptionLabel: Label)
    var viewOutcomeMode: DemoViewOutcomeMode { get }
    func showOutcome(label: Label)
    func showButtonsToResolve(happenedButton: Button, notHappenedButton: Button)
}

protocol DemoView {
    func updateOutcomeMode()
}

class DemoViewController: UIViewController, DemoView {
    var dataSource: DemoViewDataSource?

    private lazy var titleLabel = WrappedUILabel()
    private lazy var descriptionLabel = WrappedUILabel()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private struct OutcomeView {
        enum State {
            case outcome(label: WrappedUILabel)
            case buttonsToResolve(happened: WrappedUIButton, notHappened: WrappedUIButton)
        }
        let state: State
        let container: UIView
        let outcomeMode: DemoViewOutcomeMode
    }
    private var outcomeView: OutcomeView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        dataSource?.showTopContent(titleLabel: titleLabel.wrapper, descriptionLabel: descriptionLabel.wrapper)

        updateOutcomeMode()
    }

    func updateOutcomeMode() {
        guard self.isViewLoaded,
            let dataSource = dataSource
            else { return }
        let outcomeMode = dataSource.viewOutcomeMode

        if let oldOutcomeView = outcomeView {
            if oldOutcomeView.outcomeMode == outcomeMode {
                return
            } else {
                stackView.removeArrangedSubview(oldOutcomeView.container)
                outcomeView = nil
            }
        }

        let outcomeView: OutcomeView = {
            switch outcomeMode {
            case .showOutcome:
                let label = WrappedUILabel()
                dataSource.showOutcome(label: label.wrapper)
                return OutcomeView(state: .outcome(label: label),
                                      container: label,
                                      outcomeMode: outcomeMode)
            case .showButtonsToResolve:
                let happenedButton = WrappedUIButton(type: .system)
                let notHappenedButton = WrappedUIButton(type: .system)
                dataSource.showButtonsToResolve(happenedButton: happenedButton.wrapper, notHappenedButton: notHappenedButton.wrapper)
                let container = UIStackView(arrangedSubviews: [happenedButton, notHappenedButton])
                return OutcomeView(state: .buttonsToResolve(happened: happenedButton, notHappened: notHappenedButton),
                                      container: container,
                                      outcomeMode: outcomeMode)
            }
        }()
        stackView.addArrangedSubview(outcomeView.container)
        self.outcomeView = outcomeView
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct DemoViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = DemoViewController()
        let presenter = DemoPresenterImpl(view: vc)
        presenter.displayForecast(ForecastPreview.forecast1)
        vc.dataSource = presenter
        return ViewControllerPreview(viewController: vc)
    }
}
#endif
