//
//  UserSession.swift
//  Duomo
//
//  Created by Seungjin on 13/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation

class UserSession {
  
  static let shared = UserSession()
  
  var name: String? {
    guard let value = App.preference.objectForKey(key: Preference.Key.name, type: .userDefault) as? String else {
      return ""
    }

    return value
  }
  
  var email: String? {
    guard let value = App.preference.objectForKey(key: Preference.Key.email, type: .keychain) as? String else {
      return ""
    }
    
    return value
  }

  var token: String? {
    guard let value = App.preference.objectForKey(key: Preference.Key.token, type: .keychain) as? String else {
      return ""
    }
    
    return value
  }
  
}
