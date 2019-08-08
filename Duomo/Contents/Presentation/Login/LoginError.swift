//
//  LoginError.swift
//  Duomo
//
//  Created by Seungjin on 08/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation

enum LoginError: Int, Error {
  case invalidPassword = 17009
  case invalidEmail = 17011
  case badlyFormatted = 17008
  case unknown = 17999
  
  var description: String {
    switch self {
    case .invalidPassword:
      return "비밀번호가 맞지 않습니다."
    case .invalidEmail:
      return "존재하지 않는 이메일 입니다.\n이메일을 확인해주세요"
    case .badlyFormatted:
      return "잘못된 이메일 형식입니다."
    case .unknown:
      return "에러"
    }
  }

  static func error(for code: Int) -> LoginError {
    switch code {
    case 17009: return LoginError.invalidPassword
    case 17011: return LoginError.invalidEmail
    case 17008: return LoginError.badlyFormatted
    default: return LoginError.unknown
    }
  }
}
