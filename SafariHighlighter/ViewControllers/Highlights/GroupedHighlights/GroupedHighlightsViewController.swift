//
//  GroupedHighlightsViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import UIKit

final class GroupedHighlightsViewController: UIViewController {

    // MARK: - Internal

    init(groupingVCs: [HighlightsGrouping]) {
        self.groupingVCs = groupingVCs

        precondition(groupingVCs.count > 0, "Container vc is used without the content vcs")
        groupingVCs.forEach {
            precondition($0 is UIViewController, "Only UIViewControllers can implement HighlightsGrouping")
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        showController(at: visibleControllerIndex)
    }

    // MARK: - Private

    private let groupingVCs: [HighlightsGrouping]

    private var visibleControllerIndex = 0 {
        didSet {
            guard oldValue != visibleControllerIndex else { return }

            showController(at: visibleControllerIndex)
        }
    }

    // MARK: Navigation bar controls

    private func segmentedControl(for groupingVCs: [HighlightsGrouping]) -> UISegmentedControl? {
        UISegmentedControl(items: groupingVCs.map { $0.name } )
    }

    private func setupSegmentedControl() {
        let segmentedControl = segmentedControl(for: groupingVCs)
        segmentedControl?.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl?.selectedSegmentIndex = visibleControllerIndex
        navigationItem.titleView = segmentedControl
    }

    private func updateNavigationItems(forControllerAt index: Int) {
        navigationItem.rightBarButtonItems = groupingVCs[index].navigationItems
    }

    // MARK: Content controllers

    private func showController(at index: Int) {
        if let visibleChild = children.first {
            removeChildController(visibleChild)
        }

        guard let controllerToShow = groupingVCs[index] as? UIViewController else {
            return // case is not possible thanks to the precondition
        }

        addChildController(controllerToShow)
        updateNavigationItems(forControllerAt: index)
    }

    private func removeChildController(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }

    private func addChildController(_ childVC: UIViewController) {
        childVC.willMove(toParent: self)
        view.addSubview(childVC.view)
        addChild(childVC)
        childVC.view.frame = view.frame
        childVC.didMove(toParent: self)
    }

    // MARK: Actions

    @objc
    private func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        visibleControllerIndex = segmentedControl.selectedSegmentIndex
    }

}
