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

extension UIView {
  
  static var reuseIdentifier: String {
      let nameSpaceClassName = NSStringFromClass(self)
      guard let className = nameSpaceClassName.components(separatedBy: ".").last else {
          return nameSpaceClassName
      }
      return className
  }
  
  func loadNib() -> UIView? {
    let name = String(describing: type(of: self))
    guard let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
      return nil
    }
    return view
  }
  
}

extension UIView {

  func findSubView(with tag: Int) -> UIView? {
    return self.subviews.first { $0.tag == tag }
  }
}
