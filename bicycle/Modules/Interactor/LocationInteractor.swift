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
  func start() -> Observable<Bool>
  func fetchLocation() -> Observable<LocationDidUpdate>
  func fetchDistacne(lat: Double, lng: Double) -> Double
}

class LocationInteractor: LocationUseCase {
  
  let locationManager: LocationManager
  
  init(locationManager: LocationManager) {
    self.locationManager = locationManager
  }
  
  func start() -> Observable<Bool> {
    return locationManager.grantPermissions()
  }
  
  func fetchLocation() -> Observable<LocationDidUpdate> {
    return locationManager.didUpdateLocation.asObservable()
  }
  
  func fetchDistacne(lat: Double, lng: Double) -> Double {
    let from = (lat, lng)
    let current = (lat: locationManager.location?.coordinate.latitude, lng: locationManager.location?.coordinate.longitude)
    return self.locationManager.distance(current: current, from: from)
  }
  
}
