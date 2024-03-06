//
//  WeekDays.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import Foundation

enum WeekDays: String, CaseIterable, Comparable {
  
  case monday = "Понедельник"
  case tuesday = "Вторник"
  case wednesday = "Среда"
  case thursday = "Четверг"
  case friday = "Пятница"
  case saturday = "Суббота"
  case sunday = "Воскресенье"
  
  var shortcut: String {
    switch self {
    case .monday:
      return "Пн"
    case .tuesday:
      return "Вт"
    case .wednesday:
      return "Ср"
    case .thursday:
      return "Чт"
    case .friday:
      return "Пт"
    case .saturday:
      return "Сб"
    case .sunday:
      return "Вс"
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

