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
