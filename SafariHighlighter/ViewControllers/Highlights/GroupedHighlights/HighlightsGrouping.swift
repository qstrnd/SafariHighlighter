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
    var navigationItems: [UIBarButtonItem] { get }
    var delegate: HighlightsGroupingDelegate? { get set }
}
