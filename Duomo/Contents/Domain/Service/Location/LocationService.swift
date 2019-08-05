//
//  LocationService.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {
  
  //MARK: - Singleton
  static let shared = LocationService()
  
  
  //MARK: - Properties
  let manager = CLLocationManager()
  var locationDidUpdate: ( (_ location: CLLocation?,_ error: Error?) -> ())?
  var running = false
  
  
  //MARK: - Initialize
  private override init() {
    super.init()
    
    manager.delegate = self
  }
  
  
}

//MARK: - Method

extension LocationService {
  
  private func updatingLocation() {
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.startUpdatingLocation()
  }
  
  func isLocationService() -> Bool {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
      return true
    default:
      return false
    }
  }
  
}


//MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      running = false
      locationDidUpdate?(nil, LocationError.authorizationDenied)
      manager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      running = false
      locationDidUpdate?(nil, LocationError.authorizationDenied)
      manager.stopUpdatingLocation()
    case .authorizedWhenInUse, .authorizedAlways:
      running = true
      updatingLocation()
    @unknown default:
      break
    }
    
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    locationDidUpdate?(location, nil)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationDidUpdate?(nil, LocationError.authorizationDenied)
  }
}
