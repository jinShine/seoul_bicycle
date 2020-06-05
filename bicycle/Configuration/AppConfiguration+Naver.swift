//
//  AppConfiguration+Naver.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/06.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

extension AppConfiguration {
  
  private enum Keys: String {
    case cliendId = "NMFClientId"
  }
  
  var naverAppId: String? {
    guard let cliendId = self.configurations?[Keys.cliendId.rawValue] as? String,
          cliendId.count > 0 else {
              return nil
      }
      return cliendId
  }
}
