//
//  Tracker.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let sked: [WeekDays]?
    
    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, sked: [WeekDays]?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.sked = sked
    }
}

extension Tracker {
    struct Track {
        var name: String = ""
        var color: UIColor? = nil
        var emoji: String? = nil
        var sked: [WeekDays]? = nil
    }
}
