//
//  AppGlobalType.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/23.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

protocol AppGlobalRepositoryType {
  
  var appConstant: AppConstant { get }
  var seoulOpenNetwork: SeoulOpenAPIProtocol { get }
  var seoulBikeNetwork: SeoulBikeAPIProtocol { get }
  var coreData: CoreDataStorageable { get }
  var repository: AppRepository { get }
}

extension AppGlobalRepositoryType {
  
  var appConstant: AppConstant {
    return AppConstant.shared
  }
  
  var seoulOpenNetwork: SeoulOpenAPIProtocol {
    return appConstant.seoulOpenNetwork
  }
  
  var seoulBikeNetwork: SeoulBikeAPIProtocol {
    return appConstant.seoulBikeNetwork
  }
  
  var coreData: CoreDataStorageable {
    return appConstant.coreData
  }
  
  var repository: AppRepository {
    appConstant.repository
  }

}
