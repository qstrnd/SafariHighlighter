//
//  SettingsViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import UIKit
import SwiftUI

final class SettingsViewController: UIViewController {

    private enum Constants {
        static let screenName = "settings_and_info"
    }

    // MARK: - Internal

    init(
        coordinator: SettingsCoordinatorProtocol,
        tracker: TrackerProtocol
    ) {
        self.coordinator = coordinator
        self.tracker = tracker
        
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tracker.trackScreenView(name: Constants.screenName)
    }

    // MARK: - Private
    
    private let coordinator: SettingsCoordinatorProtocol
    private let tracker: TrackerProtocol

    private lazy var hostingController = UIHostingController(rootView: SettingsView(viewModel: SettingsViewModel(coordinator: coordinator)))

}
