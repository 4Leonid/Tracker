//
//  UserDefaultsBacked.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value> {
  let key: String
  let storage: UserDefaults = .standard
  
  var wrappedValue: Value? {
    get {
      storage.value(forKey: key) as? Value
    }
    set {
      storage.setValue(newValue, forKey: key)
    }
  }
}
