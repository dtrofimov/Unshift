//
//  CanvasPreview.swift
//  Unshift
//
//  Created by Dmitrii Trofimov on 28.10.2019.
//  Copyright © 2019 Dmitrii Trofimov. All rights reserved.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ViewControllerPreview: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerPreview>) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewControllerPreview>) {
    }
}
#endif
