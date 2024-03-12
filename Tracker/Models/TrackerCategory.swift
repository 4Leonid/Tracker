//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import Foundation

struct TrackerCategory: Equatable {
  let name: String
  let id: UUID
  
  init(name: String, id: UUID = UUID()) {
    self.name = name
    self.id = id
  }
  
  var data: Data {
    Data(name: name, id: id)
  }
}

extension TrackerCategory {
  struct Data {
    var name: String
    let id: UUID
    
    init(name: String = "", id: UUID? = nil) {
      self.name = name
      self.id = id ?? UUID()
    }
  }
}


