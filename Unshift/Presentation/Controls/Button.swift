//
//  Button.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 29.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit

protocol Button: AnyObject {
    var title: String { get set }
    var isEnabled: Bool { get set }
    var tapHandler: (() -> ())? { get set }
}

class WrappedUIButton: UIButton {
    private class Wrapper: ViewWrapper<WrappedUIButton>, Button {
        override func didLoad() {
            super.didLoad()
            view.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        }

        var title: String {
            get {
                view.title(for: .normal) ?? ""
            }
            set {
                guard newValue != title else { return }
                view.setTitle(newValue, for: .normal)
            }
        }

        var isEnabled: Bool {
            get {
                view.isEnabled
            }
            set {
                guard newValue != isEnabled else { return }
                view.isEnabled = newValue
            }
        }

        var tapHandler: (() -> ())?

        @objc private func didTap() {
            tapHandler?()
        }
    }

    lazy var wrapper: Button = Wrapper(view: self)
}
