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

    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
        
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
        hostingController.didMove(toParent: self)
        
        let settingsView = hostingController.view!
        view.addSubviewAlignedToEdges(settingsView)
        
    }

    // MARK: - Private
    
    private let coordinator: SettingsCoordinatorProtocol

    private lazy var hostingController = UIHostingController(rootView: SettingsView(viewModel: SettingsViewModel(coordinator: coordinator)))

}
