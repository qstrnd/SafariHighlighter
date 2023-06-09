//
//  Tracker.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 09.06.2023.
//

import Foundation
import FirebaseAnalytics

protocol TrackerProtocol {
    func trackScreenView(name: String)
    func trackScreenView(name: String, parameters: [String: String])
}

final class Tracker: TrackerProtocol {

    func trackScreenView(name: String) {
        trackScreenView(name: name, parameters: [:])
    }

    func trackScreenView(name: String, parameters: [String : String]) {
        var eventParameters = [AnalyticsParameterScreenName: name]

        for (key, value) in parameters {
            eventParameters[key] = value
        }

        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: eventParameters
        )
    }

}
