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
  func currentLocation() -> Observable<CurrentLocation>
  func currentDistacne(from location: FromLocation) -> Double
}

class LocationInteractor: LocationUseCase, AppGlobalRepositoryType {
  
  let locationManager: LocationManager
  
  init(locationManager: LocationManager = LocationManager()) {
    self.locationManager = locationManager
  }
  
  func start() -> Observable<Bool> {
    return locationManager.grantPermissions()
  }
  
  func fetchLocation() -> Observable<LocationDidUpdate> {
    return locationManager.didUpdateLocation.asObservable()
  }
  
  func currentLocation() -> Observable<CurrentLocation> {
    return locationManager.didUpdateLocation
      .map { [weak self] (location, _) in
        let lat = location?.coordinate.latitude
        let lng = location?.coordinate.longitude
        self?.appConstant.repository.currentLocation = (lat ?? 0.0, lng ?? 0.0)
        return (lat, lng)
    }
  }

  func currentDistacne(from location: FromLocation) -> Double {
    let from = (location.lat, location.lng)
    let current = (lat: appConstant.repository.currentLocation.lat,
                   lng: appConstant.repository.currentLocation.lng)
    return self.locationManager.distance(current: current, from: from)
  }
  
}
