//
//  Filter.swift
//  Tracker
//
//  Created by Леонид Турко on 18.03.2024.
//

import Foundation

// MARK: - Filter Enum
enum Filter: String , CaseIterable {
  case all
  case today
  case finished
  case unfinished
  
  var name: String {
    switch self {
    case .all:
      return "filterVC_all".localized
    case .today:
      return "filterVC_today".localized
    case .finished:
      return "filterVC_finished".localized
    case .unfinished:
      return "filterVC_unfinished".localized
    }
  }
}
