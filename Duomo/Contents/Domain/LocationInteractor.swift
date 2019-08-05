//
//  LocationInteractor.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import CoreLocation

protocol LocationUseCase {
  var locationCoordinate: Observable<CLLocationCoordinate2D> { get }
  
}

final class LocationInteractor: LocationUseCase {
  
  var locationService = App.location
  
  var locationCoordinate: Observable<CLLocationCoordinate2D> {
    return Observable<CLLocationCoordinate2D>.create { (observer) -> Disposable in
      
      self.locationService.locationDidUpdate = { location, error in
        if let error = error {
          observer.onError(error)
          return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 0,
                                                longitude: location?.coordinate.longitude ?? 0)
        observer.onNext(coordinate)
        observer.onCompleted()
      }
      
      return Disposables.create()
    }
  }
}
