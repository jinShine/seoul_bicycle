//
//  SeoulOpenAPI.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import Moya

enum SeoulOpenAPI {
  case bicycleList(start: Int, last: Int)
}

extension SeoulOpenAPI: TargetType {

  var baseURL: URL {
    return URL(string: "http://openapi.seoul.go.kr:8088/" + AppConfiguration.current().seoulBicycleId! + "/json")!
  }

  var path: String {
    switch self {
    case .bicycleList(let start, let last):
      return "/bikeList/"+String(start)+"/"+String(last)
    }
  }

  var method: Moya.Method {
    switch self {
    case .bicycleList:
      return .get
    }
  }

  var sampleData: Data {
    return "data".data(using: String.Encoding.utf8)!
  }

  var task: Task {
    switch self {
    case .bicycleList(_, _):
      return .requestPlain
    }
  }

  var headers: [String : String]? {
    return [
      "Content-Type" : "application/json"
    ]
  }
}
