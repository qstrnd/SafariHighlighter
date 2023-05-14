//
//  HighlightsGrouping.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import UIKit
import ObjectiveC

protocol HighlightsGroupingDelegate: AnyObject {
    func highlightGroupingRequestNavigationItemsUpdate(_ self: HighlightsGrouping)
}

/// A view controller that can be inserted into GroupedHighlightsViewController
protocol HighlightsGrouping: AnyObject {
    var view: UIView! { get }
    var name: String { get }
    var rightNavigationItems: [UIBarButtonItem] { get }
    var leftNavigationItems: [UIBarButtonItem] { get }
    var showSegmentedControl: Bool { get }
    var delegate: HighlightsGroupingDelegate? { get set }
}

extension HighlightsGrouping {
    var showSegmentedControl: Bool { true }
}
