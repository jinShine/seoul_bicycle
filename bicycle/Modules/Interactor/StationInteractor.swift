//
//  StationInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/23.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

protocol StationUseCase {
  @discardableResult
  func createStation(station: Station) -> Observable<Void>
  
  @discardableResult
  func stationList() -> Observable<[Station]>
  
  var stations: [Station] { get set }
  
  //  @discardableResult
  //  func delete(station: Station) -> Observable<Station>
}

class StationInteractor: StationUseCase, AppGlobalType {
  
  private var coreDataStorage: CoreDataStorageable {
    return appConstant.coreData
  }
  
  var stations: [Station] = []
  
  func createStation(station: Station) -> Observable<Void> {
    do {
      _ = try coreDataStorage.context.rx.update(station)
      return Observable.just(())
    } catch {
      return Observable.error(error)
    }
  }
  
  func stationList() -> Observable<[Station]> {
    return coreDataStorage.context.rx
      .entities(Station.self,
                predicate: nil,
                sortDescriptors: [NSSortDescriptor(key: "distance", ascending: true)])
      .do(onNext: { [weak self] in
        self?.stations.append(contentsOf: $0)
      })
  }
  //
  //  func delete(station: Station) -> Observable<Station> {
  //
  //  }
  
  
}
