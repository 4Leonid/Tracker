//
//  UIColorConvert.swift
//  Tracker
//
//  Created by Леонид Турко on 17.02.2024.
//

import UIKit

final class UIColorConvert {
  
  // MARK: - Color converter
  static func convertColorToString(color: UIColor) -> String {
    let components = color.cgColor.components ?? []
    let hex = components.reduce("#") {
      let value = Int($1 * 255)
      return $0 + String(format: "%02X", value)
    }
    return hex
  }
  
  static func convertStringToColor(hex: String) -> UIColor? {
    let startIndex = hex.index(hex.startIndex, offsetBy: 1)
    let hexColor = String(hex[startIndex...])
    if let hexNumber = UInt64(hexColor, radix: 16) {
      let r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
      let g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
      let b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
      let a = CGFloat(hexNumber & 0x000000FF) / 255
      return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    return nil 
  }
}
