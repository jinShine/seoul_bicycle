//
//  LocationManager.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

typealias LocationDidUpdate = ((_ location: CLLocation?, _ error: Error?)->())
typealias LocationResponse = (location: CLLocation?, error: LocationError?)

enum LocationError: Error {
  case authorizationDenied
}

class LocationManager: NSObject, CLLocationManagerDelegate {
  
  //MARK: Errors
  
  
  
  //MARK: Properties
  
  private lazy var locationManager: CLLocationManager? = CLLocationManager()
  private var didUpdateLocation: LocationDidUpdate?
  
  var running = false
  
  deinit {
    stopMonitoringUpdates()
  }
  
  //MARK: Methods
  
  func grantPermissions() {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined:
      locationManager?.requestWhenInUseAuthorization()
    case .restricted, .denied:
      break
    case .authorizedWhenInUse, .authorizedAlways:
      self.startMonitoringUpdates()
    @unknown default:
      fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
    }
  }
  
  func startMonitoringUpdates() {
    locationManager?.distanceFilter = kCLDistanceFilterNone
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    locationManager?.pausesLocationUpdatesAutomatically = true
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.delegate = self
    locationManager?.startUpdatingLocation()
  }
  
  func stopMonitoringUpdates() {
    didUpdateLocation = nil
    locationManager?.stopUpdatingLocation()
    locationManager?.allowsBackgroundLocationUpdates = false
    locationManager?.disallowDeferredLocationUpdates()
    locationManager?.delegate = nil
    running = false
  }
  
  //MARK: Location Authorization Status Changed
  
  //MARK: Location Manager Delegate
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations.last)
  }
  
}
