//
//  SettingsViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import UIKit
import SwiftUI

final class SettingsViewController: UIViewController {

    // MARK: - Internal

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hostingController.willMove(toParent: self)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.frame
        hostingController.didMove(toParent: self)
    }

    // MARK: - Private

    private let hostingController = UIHostingController(rootView: SettingsView())

}
