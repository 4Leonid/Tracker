//
//  Date+Extention.swift
//  Tracker
//
//  Created by Леонид Турко on 04.03.2024.
//

import Foundation

extension Date {
  func timeLess() -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: components)!
  }
}
