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
}
