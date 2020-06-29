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

class LocationInteractor: LocationUseCase {
  
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
      .map { (location, _) in
        let lat = location?.coordinate.latitude
        let lng = location?.coordinate.longitude
        return (lat, lng)
    }
  }

  func currentDistacne(from location: FromLocation) -> Double {
    let from = (location.lat, location.lng)
    let current = (lat: locationManager.location?.coordinate.latitude,
                   lng: locationManager.location?.coordinate.longitude)
    return self.locationManager.distance(current: current, from: from)
  }
  
}
