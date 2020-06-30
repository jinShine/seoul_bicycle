//
//  StationInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/23.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreData

protocol StationUseCase {
  
//  var likeStations: [Station] { get set }
  
  @discardableResult
  func createStation(station: Station) -> Observable<Void>
  
  @discardableResult
  func readLikeStation() -> Observable<[Station]>
  
  @discardableResult
  func delete(station: Station) -> Observable<Station>
}

class StationInteractor: StationUseCase, AppGlobalRepositoryType {
  
  var likeStations: [Station] = []
  
  private var coreDataStorage: CoreDataStorageable {
    return appConstant.coreData
  }
  
  func createStation(station: Station) -> Observable<Void> {
    do {
      try coreDataStorage.context.rx.update(station)
      return Observable.just(())
    } catch {
      return Observable.error(error)
    }
  }
  
  func readLikeStation() -> Observable<[Station]> {
    return coreDataStorage.context.rx
      .entities(Station.self,
                predicate: nil,
                sortDescriptors: [NSSortDescriptor(key: "distance", ascending: true)])
  }
  
  func delete(station: Station) -> Observable<Station> {
    do {
      _ = try coreDataStorage.context.rx.delete(station)
      return Observable.just(station)
    } catch {
      return Observable.error(error)
    }
  }
  
  func removeAll() {
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
    do {
      try self.coreDataStorage.context.execute(deleteRequest)
      try self.coreDataStorage.context.save()
    } catch {
      print ("There is an error in deleting records")
    }
  }
  
}
