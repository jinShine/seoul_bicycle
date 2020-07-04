//
//  SeoulBikeAPI.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/02.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import Moya

enum SeoulBikeAPI {
  case login(id: String, pw: String)
}

extension SeoulBikeAPI: TargetType {
  
  var baseURL: URL {
    return URL(string: "http://www.bikeseoul.com")!
  }

  var path: String {
    switch self {
    case .login: return "/j_spring_security_check"
    }
  }

  var method: Moya.Method {
    switch self {
    case .login:
      return .get
    }
  }

  var sampleData: Data {
    return "data".data(using: String.Encoding.utf8)!
  }

  var task: Task {
    switch self {
    case .login(let id, let pw):
      return .requestParameters(parameters: [
        "j_username": id,
        "j_password": pw
      ], encoding: JSONEncoding.default)
    }
  }

  var headers: [String : String]? {
    return [
      "Content-Type": "application/x-www-form-urlencoded"
    ]
  }
}
