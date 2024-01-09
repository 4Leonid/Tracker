//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import Foundation

struct TrackerCategory {
    let name: String
    let trackersArray: [Tracker]
}

extension TrackerCategory {
    static let defaultValue: [TrackerCategory] =
    [
        TrackerCategory(name: "Важное", trackersArray: [])
    ]
}
