//
//  AppDelegate.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/04.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    
    setupRootViewController()

    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if KOSession.isKakaoAccountLoginCallback(url) {
      return KOSession.handleOpen(url)
    }
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
  }
  
  
}

extension AppDelegate {
  
  private func setupRootViewController() {
    if let navigationController = window?.rootViewController as? UINavigationController,
      let viewController = navigationController.viewControllers.first,
      let loginViewController = viewController as? LoginViewController {
      let viewModel = LoginViewModel(signinUseCase: SignInInteractor())
      loginViewController.viewModel = viewModel
    }
  }
}
