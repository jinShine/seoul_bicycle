//
//  App.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit

struct App {
  static let delegate = UIApplication.shared.delegate as! AppDelegate
  static let preference = UserDefaults.standard
  static let location = LocationService.shared
  static let network = NetworkService.shared
  static let firestore = FirestoreDB.shared
}
