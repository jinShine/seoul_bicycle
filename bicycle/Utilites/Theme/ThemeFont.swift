//
//  ThemeFont.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/13.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

struct ThemeFont {
  
  func custom(size: CGFloat) -> UIFont {
    return UIFont(name: "JeonggamDisplay-App", size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
