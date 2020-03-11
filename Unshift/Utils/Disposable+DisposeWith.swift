//
//  Disposable+DisposeWith.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 11.03.2020.
//  Copyright © 2020 Dmitrii Trofimov. All rights reserved.
//

import RxSwift

extension Disposable {
    func dispose(with holder: NSObject) {
        _ = holder.rx.deallocated.bind { _ in
            self.dispose()
        }
    }
}
