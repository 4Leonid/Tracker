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
  let daysCount: Int
  
  init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, sked: [WeekDays]?, daysCount: Int) {
    self.id = id
    self.name = name
    self.color = color
    self.emoji = emoji
    self.sked = sked
    self.daysCount = daysCount
  }
}

extension Tracker {
  struct Track {
    var name: String = ""
    var color: UIColor? = nil
    var emoji: String? = nil
    var sked: [WeekDays]? = nil
    var daysCount = 0
  }
}
