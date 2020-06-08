//
//  LocationInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

protocol LocationUseCase {
  func start() -> Observable<Void>
}

class LocationInteractor: LocationUseCase {
  
  let locationManager: LocationManager
  
  init(locationManager: LocationManager) {
    self.locationManager = locationManager
  }
  
  func start() -> Observable<Void> {
    return Observable<Void>.just(locationManager.grantPermissions())
  }
  
//  func fetch() -> Observable<LocationResponse> {
//    return Observable.create { observer -> Disposable in
//
//      self.locationManager
//    }
//  }
  
}
