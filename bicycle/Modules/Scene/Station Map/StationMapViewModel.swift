//
//  StationMapViewModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StationMapViewModel: BaseViewModel, ViewModelType {
  
  struct Input {
    let trigger: Observable<Void>
  }
  
  struct Output {
    let locationGrantPermission: Driver<Bool>
    let fetchBicycleLists: Driver<[Station]>
    let updateLocation: Driver<((Double?, Double?), Error?)>
    let locationForCameraMove: Driver<(Double, Double)>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  
  var stationLists: [Station] = []
  var currentCoordinate: (lat: Double, lng: Double) = (0.0, 0.0)
  
  init(locationInteractor: LocationUseCase, seoulBicycleInteractor: SeoulBicycleUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulBicycleInteractor = seoulBicycleInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let locationGrantPermission = locationInteractor
      .start().asDriver(onErrorJustReturn: false)
    
    let fetchBicycleList1 = seoulBicycleInteractor
      .fetchBicycleList(start: 1, last: 1000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchBicycleList2 = seoulBicycleInteractor
      .fetchBicycleList(start: 1001, last: 2000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchBicycleList3 = seoulBicycleInteractor
      .fetchBicycleList(start: 2001, last: 3000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchBicycleLists = Observable<[Station]>.concat([
        fetchBicycleList1,
        fetchBicycleList2,
        fetchBicycleList3
      ]).asDriver(onErrorJustReturn: [])

    
    let updateLocation = locationInteractor
      .fetchLocation()
      .map { (location, error) -> ((Double?, Double?), Error?) in

        let lat = location?.coordinate.latitude ?? 0.0
        let lng = location?.coordinate.longitude ?? 0.0

        self.currentCoordinate = (lat, lng)
        
        return ((lat, lng), error)
      }
      .asDriver(onErrorJustReturn: ((37.5666805, 126.9784147), nil))
    
    let locationForCameraMove = locationInteractor
      .fetchLocation()
      .map { (location, _) in
        return (location?.coordinate.latitude ?? self.currentCoordinate.lat,
                location?.coordinate.longitude ?? self.currentCoordinate.lng)
      }
      .take(1)
      .asDriver(onErrorJustReturn: currentCoordinate)

    return Output(locationGrantPermission: locationGrantPermission,
                  fetchBicycleLists: fetchBicycleLists,
                  updateLocation: updateLocation,
                  locationForCameraMove: locationForCameraMove)
  }
}
