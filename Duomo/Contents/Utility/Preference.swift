//
//  Preference.swift
//  Duomo
//
//  Created by Seungjin on 12/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation
import KeychainAccess

struct Preference {
  
  // Singleton
  static let standard = Preference()
  

  // KEY
  struct Key {
    static let email = "com.jinnify.duomo.key.email"
    static let token = "com.jinnify.duomo.key.token"
    static let password = "com.jinnify.duomo.key.password"
  }
  
  
  enum PersistenceType: Int {
    case userDefault, keychain
  }
  
  
  private init() {
    
  }
  
  
}

//MARK: - UserDefaults
extension Preference {
  
  private func setObjectInUserDefault(object: Any?, key: String) {
    UserDefaults.standard.set(object, forKey: key)
  }
  
  private func objectFromUserDefault(key: String) -> Any? {
    return UserDefaults.value(forKey: key)
  }
  
  private func removeObjectFromUserdefault(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
  }
  
  private func resetUserDefault(_ keepKeys: [String]? = nil) {
    let userDefault = UserDefaults.standard
    
    guard let keys = keepKeys, keys.count > 0 else {
      return
    }
    
    let userKeys = userDefault.dictionaryRepresentation().keys
    let deletableKeys = userKeys.filter(<#T##isIncluded: (String) throws -> Bool##(String) throws -> Bool#>)
    
    
  }
  
}


//MARK: - Keychain
extension Preference {
  
}
