//
//  AppRepository.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/29.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift

class AppRepository {
  
  var updatedDate: BehaviorSubject = BehaviorSubject<String>(value: "")
  var stationList: BehaviorSubject = BehaviorSubject<[Station]>(value: [])
}
