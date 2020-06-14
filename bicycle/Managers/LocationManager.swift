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

typealias LocationDidUpdate = (location: CLLocation?, error: Error?)
typealias LocationResponse = (location: CLLocation?, error: LocationError?)

enum LocationError: Error {
  case authorizationDenied
}

class LocationManager: NSObject, CLLocationManagerDelegate {
  
  //MARK: Properties
  
  private lazy var locationManager: CLLocationManager? = CLLocationManager()
  var didUpdateLocation = PublishSubject<LocationDidUpdate>()
  var running = BehaviorSubject<Bool>(value: false)
  var permissionStatus = BehaviorSubject<Bool>(value: false)
  
  deinit {
    stopMonitoringUpdates()
  }
  
  //MARK: Methods
  
  func grantPermissions() -> Observable<Bool> {
    return Observable<Bool>.create { observer -> Disposable in
      let status = CLLocationManager.authorizationStatus()
      switch status {
      case .notDetermined:
        self.locationManager?.requestWhenInUseAuthorization()
        self.startMonitoringUpdates()
        self.permissionStatus.onNext(true)
        observer.onNext(true)
      case .restricted, .denied:
        self.permissionStatus.onNext(false)
        observer.onNext(false)
      case .authorizedWhenInUse, .authorizedAlways:
        self.startMonitoringUpdates()
        self.permissionStatus.onNext(true)
        observer.onNext(true)
      @unknown default:
        fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
      }

      return Disposables.create()
    }
  }
  
  func startMonitoringUpdates() {
    locationManager?.distanceFilter = kCLDistanceFilterNone
    locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager?.pausesLocationUpdatesAutomatically = true
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.delegate = self
    locationManager?.startUpdatingLocation()
  }
  
  func stopMonitoringUpdates() {
    didUpdateLocation.onNext((nil, nil))
    locationManager?.stopUpdatingLocation()
    locationManager?.allowsBackgroundLocationUpdates = false
    locationManager?.disallowDeferredLocationUpdates()
    locationManager?.delegate = nil
    running.onNext(false)
  }

  //MARK: Location Manager Delegate
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error ", error)
    didUpdateLocation.onNext((nil, error))
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    didUpdateLocation.onNext((location, nil))
    print("didUpdateLocations :", location)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      running.onNext(true)
      permissionStatus.onNext(true)
      locationManager?.startUpdatingLocation()
    case .denied, .restricted, .notDetermined:
      fallthrough
    default:
      didUpdateLocation.onNext((nil, LocationError.authorizationDenied))
      locationManager?.stopUpdatingLocation()
      running.onNext(false)
      permissionStatus.onNext(true)
    }
  }
}
