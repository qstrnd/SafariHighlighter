//
//  PlaceholderViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 14.05.2023.
//

import UIKit
import SwiftUI

final class PlaceholderViewController: UIViewController {

    // MARK: - Internal

    init(text: String = "") {
        hostingController = UIHostingController(rootView: PlaceholderView(text: text))
        
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
        
        let placeholderView = hostingController.view!
        view.addSubviewAlignedToEdges(placeholderView)
        
    }

    // MARK: - Private
    
    private let hostingController: UIHostingController<PlaceholderView>

}
