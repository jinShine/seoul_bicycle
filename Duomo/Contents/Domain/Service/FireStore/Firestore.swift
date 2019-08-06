//
//  Firestore.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/07.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreDB: NSObject {
  
  static let shared = FirestoreDB()
  
  var db: Firestore!
  private override init() {
    db = Firestore.firestore()
  }
  
}

//MARK: - Method
extension FirestoreDB {
  
  func create(collection: String, data: [String : Any], completion: ((Error?) -> Void)?) {
    db.collection(collection).addDocument(data: data, completion: completion)
  }
  
}
