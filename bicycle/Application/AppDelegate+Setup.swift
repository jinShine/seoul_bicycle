//
//  AppDelegate+Setup.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/23.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit
import NMapsMap
import Firebase

extension AppDelegate: AppGlobalRepositoryType {
  
  func setup(application: UIApplication,
             launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    //Show initial screen
    appConstant.presentInitialScreen(in: self.window)
    
    //Naver Map
    NMFAuthManager.shared().clientId = AppConfiguration.current().naverAppId
    
    //Firebase
    FirebaseApp.configure()
  }
}
