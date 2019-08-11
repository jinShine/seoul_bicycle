//
//  FindPasswordError.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/09.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation

enum FindPasswordError: Int, Error {
  case notFoundUser = 17011
  case unknown
  
  var description: String {
    switch self {
    case .notFoundUser:
      return "등록되지 않은 이메일 입니다."
    default:
      return "비밀번호 재설정 이메일 전송 실패"
    }
  }
  
  static func error(for code: Int) -> FindPasswordError {
    switch code {
    case 17011: return FindPasswordError.notFoundUser
    default: return FindPasswordError.unknown
    }
  }
}
