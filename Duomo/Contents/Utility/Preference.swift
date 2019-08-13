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
  private init() { }
  
  // Properties
  private let keyChain = Keychain()
  
  
  // KEY
  struct Key {
    static let name = "com.jinnify.duomo.key.name"
    static let email = "com.jinnify.duomo.key.email"
    static let token = "com.jinnify.duomo.key.token"
  }
  
  
  enum PersistenceType: Int {
    case userDefault, keychain
  }
  
  func setObject(object: Any?, key: String, type: PersistenceType) {
    if type == .keychain {
      setObjectInKeychain(object: object, key: key)
    } else {
      setObjectInUserDefault(object: object, key: key)
    }
  }
  
  func objectForKey(key: String, type: PersistenceType) -> Any? {
    var value: Any?
    if type == .keychain {
      value = objectFromKeychain(key: key)
    } else {
      value = objectFromUserDefault(key: key)
    }
    
    return value
  }
  
  func removeObject(key: String, type: PersistenceType) {
    if type == .keychain {
      removeObjectFromKeychain(key: key)
    } else {
      removeObjectFromUserdefault(key: key)
    }
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
  
}


//MARK: - Keychain
extension Preference {
  
  private func setObjectInKeychain(object: Any?, key: String) {
    guard let obj = object as? String else {
      return
    }
    keyChain[key] = obj
  }
  
  private func objectFromKeychain(key: String) -> Any? {
    return keyChain[key]
  }
  
  private func removeObjectFromKeychain(key: String) {
    try? keyChain.remove(key)
  }
  
}
