//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import Foundation

struct TrackerRecord: Hashable {
  let id: UUID
  let date: Date
  let trackerId: UUID
  let complited: Bool
  
  init(id: UUID = UUID(), date: Date, trackerId: UUID, complited: Bool) {
    self.id = id
    self.date = date
    self.trackerId = trackerId
    self.complited = complited
  }
}
