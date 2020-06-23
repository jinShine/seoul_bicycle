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
  
  func fetchBicycleList(start: Int, last: Int) -> Single<RentStationStatus>
}

class SeoulBicycleInteractor: SeoulBicycleUseCase, AppGlobalType {
  
  private var service: Networkable {
    return appConstant.network
  }

  func fetchBicycleList(start: Int, last: Int) -> Single<RentStationStatus> {
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
}
