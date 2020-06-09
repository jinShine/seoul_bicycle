//
//  CALayer+Addition.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/10.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

//MARK: - CALayer
//Sketch 스타일
extension CALayer {
  func applyShadow (
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4
  ) {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
  }
}
