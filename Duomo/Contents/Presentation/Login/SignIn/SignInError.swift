//
//  SignInError.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation

//MARK: - Error
enum SignInErrors: String, Error {
  case name = "이름을 확인해주세요."
  case email = "이메일 형식이 잘못되었습니다."
  case password = "비밀번호 형식이 잘못되었습니다."
  case confirmPassword = "비밀번호가 일치하지 않습니다."
  case empty = "해당 입력란을 모두 채워주세요."
}
