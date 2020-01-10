//
//  Button.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 29.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit

protocol Button: AnyObject {
    var tapHandler: (() -> ())? { get set }
}

class WrappedUIButton: UIButton {
    fileprivate class Wrapper: ViewWrapper<WrappedUIButton>, Button {
        override func didLoad() {
            super.didLoad()
            view.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        }

        var tapHandler: (() -> ())?

        @objc private func didTap() {
            tapHandler?()
        }
    }

    lazy var wrapper: Button &
        KeepingTitle &
        Disableable
        = Wrapper(view: self)
}

extension WrappedUIButton.Wrapper: KeepingTitle {
    var title: String {
        get {
            view.title(for: .normal) ?? ""
        }
        set {
            guard newValue != title else { return }
            view.setTitle(newValue, for: .normal)
        }
    }
}

extension WrappedUIButton.Wrapper: Disableable {
    var isEnabled: Bool {
        get {
            view.isEnabled
        }
        set {
            guard newValue != isEnabled else { return }
            view.isEnabled = newValue
        }
    }
}
