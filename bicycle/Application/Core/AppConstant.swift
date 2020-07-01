//
//  Application.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/04.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class AppConstant: NSObject {
  
  var window: UIWindow?
  var navigator: Navigator
  var coreData: CoreDataStorageable
  var network: Networkable
  var repository: AppRepository
  
  private override init() {
    self.navigator = Navigator.default
    self.coreData = CoreDataStorage.shared
    self.network = NetworkService()
    self.repository = AppRepository()
    super.init()
  }
  
  func presentInitialScreen(in window: UIWindow?) {
    guard let window = window else { return }
    self.window = window
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      let viewModel = HomeTabBarViewModel()
//      window.rootViewController = self.navigator.get(for: .tabs(viewModel: viewModel))
//      window.backgroundColor = .white
//      window.makeKeyAndVisible()
//    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      let viewModel = SignInViewModel()
      window.rootViewController = self.navigator.get(for: .signIn(viewModel: viewModel))
      window.backgroundColor = .white
      window.makeKeyAndVisible()
    }
  }
  
}

extension AppConstant {
  static let shared = AppConstant()
}
