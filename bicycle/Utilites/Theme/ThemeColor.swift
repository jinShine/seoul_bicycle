//
//  ThemeColor.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

struct ThemeColor {
  
  var white: UIColor { .white }
  var black: UIColor { .black }
  var main: UIColor { UIColor.rgb(r: 111, g: 76, b: 255, a: 1) }
  var subMain: UIColor { UIColor.rgb(r: 255, g: 168, b: 0, a: 1)}
  var blueMagenta: UIColor { UIColor.rgb(r: 76, g: 75, b: 94, a: 1) }
  var separator: UIColor { UIColor.rgb(r: 235, g: 235, b: 235, a: 1) }
  var lightGray: UIColor { UIColor.rgb(r: 199, g: 199, b: 212, a: 1) }
  var gray: UIColor { return UIColor.rgb(r: 128, g: 128, b: 128, a: 1) }
  var subline: UIColor { return UIColor.rgb(r: 242, g: 242, b: 249, a: 1) }
  var subWhite: UIColor { return UIColor.rgb(r: 242, g: 242, b: 243, a: 1) }
}
