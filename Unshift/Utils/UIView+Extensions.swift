//
//  UIView+Extensions.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 13.02.2020.
//  Copyright © 2020 Dmitrii Trofimov. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    @objc func addSubviewAndLayoutToEdges(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.snp.makeConstraints { $0.edges.equalToSuperview().inset(insets) }
    }
}
