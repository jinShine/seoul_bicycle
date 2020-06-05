//
//  Navigator.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/04.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class Navigator {
  
  enum Scene {
    case tabs
  }
  
  func navigate(to scene: Scene) -> UIViewController {
    switch scene {
    case .tabs:
      let vc = HomeTabBarController()
      return vc
    default:
      return UIViewController()
    }
  }
}

extension Navigator {
  
  static let `default` = Navigator()
}
