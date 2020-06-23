//
//  CoreDataStorage.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/22.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import CoreData
import RxCoreData
import RxSwift

protocol CoreDataStorageable: class {
  var container: NSPersistentContainer? { get }
  var context: NSManagedObjectContext { get }
}

class CoreDataStorage: CoreDataStorageable {
  
  var container: NSPersistentContainer?

  var context: NSManagedObjectContext {
    guard let context = container?.viewContext else { fatalError("NSManagedObjectContext error") }
    return context
  }
  
  //MARK:- Init
  
  private init() {
    setupModel(name: "bicycle")
  }
  
  //MARK:- Methods
  
  private func setupModel(name: String) {
    container = NSPersistentContainer(name: name)
    container?.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("LoadPersistentStores error \(error), \(error.userInfo)")
      }
    })
  }
}

extension CoreDataStorage {
  
  static let shared = CoreDataStorage()
}
