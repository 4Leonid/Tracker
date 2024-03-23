//
//  WeekDays.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import Foundation

enum WeekDays: String, CaseIterable, Comparable {
  
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday
  
  var fullForm: String {
    switch self {
    case .monday:
      return "monday".localized
    case .tuesday:
      return "tuesday".localized
    case .wednesday:
      return "wednesday".localized
    case .thursday:
      return "thursday".localized
    case .friday:
      return "friday".localized
    case .saturday:
      return "saturday".localized
    case .sunday:
      return "sunday".localized
    }
  }
  
  var shortcut: String {
    switch self {
    case .monday:
      return "mondayShort".localized
    case .tuesday:
      return "tuesdayShort".localized
    case .wednesday:
      return "wednesdayShort".localized
    case .thursday:
      return "thursdayShort".localized
    case .friday:
      return "fridayShort".localized
    case .saturday:
      return "saturdayShort".localized
    case .sunday:
      return "sundayShort".localized
    }
  }
  
  static func < (lhs: WeekDays, rhs: WeekDays) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
  
  // MARK: - WeekDays Converter
  static func transformedSked(value: [WeekDays]?) -> String? {
    guard let value = value else { return nil }
    let index = value.map { self.allCases.firstIndex(of: $0) }
    var result = ""
    for i in 0..<7 {
      if index.contains(i) {
        result += "1"
      } else {
        result += "0"
      }
    }
    return result
  }
  
  static func reversTransformedSked(value: String?) -> [WeekDays]? {
    guard let value = value else { return nil }
    var weekdays = [WeekDays]()
    for (index,char) in value.enumerated() {
      guard char == "1" else { continue }
      let weekday = self.allCases[index]
      weekdays.append(weekday)
    }
    return weekdays
  }
}
