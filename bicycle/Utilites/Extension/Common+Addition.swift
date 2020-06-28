//
//  Common+Addition.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/27.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

extension Double {
  
  var toMeter: String {
    if self > 1000 {
      return String(format: "%.1fkm", self / 1000)
    } else {
      return String(format: "%dm", Int(self))
    }
  }
}

extension Date {
  
  var current: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "a h시 mm분에 업데이트 됨"
    return dateFormatter.string(from: date)
  }
}
