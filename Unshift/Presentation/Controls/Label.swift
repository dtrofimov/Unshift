//
//  Label.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 28.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

import UIKit

protocol Label: AnyObject {
    var text: String { get set }
}

class WrappedUILabel: UILabel {
    private class Wrapper: ViewWrapper<WrappedUILabel>, Label {
        var text: String {
            get {
                view.text ?? ""
            }
            set {
                guard newValue != text else { return }
                view.text = newValue
            }
        }
    }

    lazy var wrapper: Label = Wrapper(view: self)
}
