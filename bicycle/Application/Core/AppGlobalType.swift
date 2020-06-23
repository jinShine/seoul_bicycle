//
//  AppGlobalType.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/23.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

protocol AppGlobalType {
  
  var appConstant: AppConstant { get }
  var network: Networkable { get }
  var coreData: CoreDataStorageable { get }
}

extension AppGlobalType {
  
  var appConstant: AppConstant {
    return AppConstant.shared
  }
  
  var network: Networkable {
    return appConstant.network
  }
  
  var coreData: CoreDataStorageable {
    return appConstant.coreData
  }

}
