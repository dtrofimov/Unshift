//
//  ViewWrapper.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 31.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

class ViewWrapper<View: AnyObject> {
    unowned var view: View

    init(view: View) {
        self.view = view
        didLoad()
    }

    func didLoad() {
    }
}
