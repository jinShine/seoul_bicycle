//
//  Application.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/04.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class Application: NSObject {
  
  var window: UIWindow?
  var navigator: Navigator
  
  private override init() {
    self.navigator = Navigator.default
    
    super.init()
  }
  
  func presentInitialScreen(in window: UIWindow?) {
    guard let window = window else { return }
    self.window = window
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      let viewModel = HomeTabBarViewModel()
      window.rootViewController = self.navigator.get(for: .tabs(viewModel: viewModel))
      window.backgroundColor = .white
      window.makeKeyAndVisible()
    }
  }
}

extension Application {
  static let shared = Application()
}
