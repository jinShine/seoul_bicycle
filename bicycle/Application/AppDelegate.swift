//
//  AppDelegate.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/03.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.setup(application: application, launchOptions: launchOptions)
    return true
  }
  
}

