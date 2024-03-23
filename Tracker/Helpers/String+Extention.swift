//
//  String+Extention.swift
//  Tracker
//
//  Created by Леонид Турко on 14.03.2024.
//

import Foundation

extension String {
  
  var localized: String {
    NSLocalizedString(
      self,
      comment: "\(self) could not be found in Localizable.strings"
    )
  }
}
