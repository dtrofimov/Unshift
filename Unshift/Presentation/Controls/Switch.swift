//
//  Switch.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 28.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit

protocol Switch: AnyObject {
    var value: Bool { get set }
    var valueDidChangeHandler: ((Bool) -> ())? { get set }
}

class WrappedUISwitch: UISwitch {
    private class Wrapper: ViewWrapper<WrappedUISwitch>, Switch {
        override func didLoad() {
            super.didLoad()
            view.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        }

        var value: Bool {
            get {
                view.isOn
            }
            set {
                guard newValue != value else { return }
                view.isOn = newValue
            }
        }

        var valueDidChangeHandler: ((Bool) -> ())?

        @objc private func valueDidChange() {
            valueDidChangeHandler?(value)
        }
    }

    lazy var wrapper: Switch = Wrapper(view: self)
}
