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
    let fetchBicycleListTrigger: Observable<Void>
    let didTapUpdateStation: Observable<Void>
    let didTapUpdateLocation: Observable<Void>
    let didTapStationContainer: Observable<Void>
  }
  
  struct Output {
    let locationGrantPermission: Driver<Bool>
    let fetchBicycleLists: Observable<[Station]>
    let updateLocation: Driver<((Double?, Double?), Error?)>
    let locationForCameraMove: Driver<(Double, Double)>
    let updateStation: Observable<[Station]>
    let updateCurrentLocation: Driver<Void>
    let showStationSearch: Driver<[Station]>
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
    
    // 2000개 이상 Station이 생겼는지 확인해보기~
    let fetchBicycleList3 = seoulBicycleInteractor
      .fetchBicycleList(start: 2001, last: 3000)
      .map { $0.status.row }
      .asObservable()
    
    let bicycleLists = Observable<[Station]>.concat([
        fetchBicycleList1,
        fetchBicycleList2,
        fetchBicycleList3
      ])
      .catchErrorJustReturn([])
      .map {
        $0.map { [weak self] station -> Station in
          let distance = self?.locationInteractor.currentDistacne(
            from: (Double(station.stationLatitude), Double(station.stationLongitude))
          )
          return Station(rackTotCnt: station.rackTotCnt,
                         stationName: station.stationName,
                         parkingBikeTotCnt: station.parkingBikeTotCnt,
                         shared: station.shared,
                         stationLatitude: station.stationLatitude,
                         stationLongitude: station.stationLongitude,
                         stationId: station.stationId,
                         distacne: distance)
        }
      }
      .reduce([], accumulator: { $0 + $1 })
      .do(onNext: {
        self.stationLists.removeAll(keepingCapacity: true)
        self.stationLists.append(contentsOf: $0 )}
      )
    
    let fetchBicycleLists = input.fetchBicycleListTrigger
      .flatMap { bicycleLists }
    
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
    
    let updateStation = input.didTapUpdateStation
      .flatMap { bicycleLists }
      .asObservable()
    
    let updateCurrentLocation = input.didTapUpdateLocation
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    let showStationSearch = input.didTapStationContainer
      .map { self.stationLists }
      .asDriver(onErrorJustReturn: [])
    
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchBicycleLists: fetchBicycleLists,
                  updateLocation: updateLocation,
                  locationForCameraMove: locationForCameraMove,
                  updateStation: updateStation,
                  updateCurrentLocation: updateCurrentLocation,
                  showStationSearch: showStationSearch)
  }
}
