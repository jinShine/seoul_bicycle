//
//  UIView+Addition.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/08.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

extension UIView {
  
  var hasTopNotch: Bool {
    if #available(iOS 13.0,  *) {
      return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
    }else{
      return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
  }
  
  var topNotchHeight: CGFloat {
    if #available(iOS 13.0,  *) {
      return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
    }else{
      return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
    }
  }
  
}
