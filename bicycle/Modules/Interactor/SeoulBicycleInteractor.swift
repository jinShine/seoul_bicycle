//
//  SeoulBicycleInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift

protocol SeoulBicycleUseCase {
  
  func fetchStations() -> Observable<[Station]>
}

class SeoulBicycleInteractor: SeoulBicycleUseCase, AppGlobalRepositoryType {
  
  private var service: Networkable {
    return appConstant.network
  }

  private func stationRequest(start: Int, last: Int) -> Single<RentStationStatus> {
    return service.buildRequest(to: .bicycleList(start: start, last: last))
      .map { response in
        return try JSONDecoder().decode(RentStationStatus.self, from: response.jsonData ?? Data())
    }
    .catchError { error in
      return Single.create { single -> Disposable in
        single(.error(error))
        return Disposables.create()
      }
    }
  }
  
  func fetchStations() -> Observable<[Station]> {
    let fetchStations1 = stationRequest(start: 1, last: 1000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchStations2 = stationRequest(start: 1001, last: 2000)
      .map { $0.status.row }
      .asObservable()
    
    // 2000개 이상 Station이 생겼는지 확인해보기~
    let fetchStations3 = stationRequest(start: 2001, last: 3000)
      .map { $0.status.row }
      .asObservable()
    
    return Observable<[Station]>
      .concat([fetchStations1, fetchStations2, fetchStations3])
      .catchErrorJustReturn([])
      .reduce([], accumulator: { $0 + $1 })
  }
}
