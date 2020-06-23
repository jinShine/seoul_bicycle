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
    let didTapLikeInMarkerInfo: Observable<Int>
  }
  
  struct Output {
    let locationGrantPermission: Driver<Bool>
    let fetchStationLists: Observable<[Station]>
    let updateLocation: Driver<((Double?, Double?), Error?)>
    let locationForCameraMove: Driver<(Double, Double)>
    let updateStation: Observable<[Station]>
    let updateCurrentLocation: Driver<Void>
    //    let showStationSearch: Driver<[Station]>
    //    let saveStation: Driver<Void>
    let stationList: Driver<[Station]>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  let stationInteractor: StationUseCase
  
  var stationLists = BehaviorSubject<[Station]>(value: [])
  var currentCoordinate: (lat: Double, lng: Double) = (0.0, 0.0)
  
  init(locationInteractor: LocationUseCase,
       seoulBicycleInteractor: SeoulBicycleUseCase,
       stationInteractor: StationUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulBicycleInteractor = seoulBicycleInteractor
    self.stationInteractor = stationInteractor
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
    
    let saveStations = Observable<[Station]>.concat([
      fetchBicycleList1,
      fetchBicycleList2,
      fetchBicycleList3
    ])
      .catchErrorJustReturn([])
      .reduce([], accumulator: { $0 + $1 })
      .map {
        return $0.enumerated().map { [weak self] (index, station) in
          let distance = self?.locationInteractor.currentDistacne(
            from: (Double(station.stationLatitude),
                   Double(station.stationLongitude))
          )
          
          let likeStatus = self?.stationInteractor.stations
            .compactMap { $0.id }
            .filter { $0 == index }
            .first

          if likeStatus == index {
            self?.stationInteractor.createStation(station:
              Station(id: index,
                      rackTotCnt: station.rackTotCnt,
                      stationName: station.stationName,
                      parkingBikeTotCnt: station.parkingBikeTotCnt,
                      shared: station.shared,
                      stationLatitude: station.stationLatitude,
                      stationLongitude: station.stationLongitude,
                      stationId: station.stationId,
                      distacne: distance,
                      like: true)
              )
          } else {
            self?.stationInteractor.createStation(station:
              Station(id: index,
                      rackTotCnt: station.rackTotCnt,
                      stationName: station.stationName,
                      parkingBikeTotCnt: station.parkingBikeTotCnt,
                      shared: station.shared,
                      stationLatitude: station.stationLatitude,
                      stationLongitude: station.stationLongitude,
                      stationId: station.stationId,
                      distacne: distance,
                      like: false)
            )
          }
        }

      }.mapToVoid()
//    .do(onNext: { self.stationLists.onNext($0) })
    
    //    .map { self.stationLists.onNext($0) }
    //    .do(onNext: {
    //      self.stationLists.onNext($0)
    //      self.stationLists.removeAll(keepingCapacity: true)
    //      self.stationLists.append(contentsOf: $0 )}
    //    )
    
    let fetchStationLists = input.fetchBicycleListTrigger
      .flatMap { saveStations }
      .flatMap { self.stationInteractor.stationList() }
      
    
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
      .flatMap { saveStations }
      .flatMap { self.stationInteractor.stationList() }

    let updateCurrentLocation = input.didTapUpdateLocation
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    let showStationSearch = input.didTapStationContainer
      .map { self.stationLists }
      .asDriver(onErrorJustReturn: .init(value: []))
    
    //    let saveStation = input.didTapLikeInMarkerInfo
    //      .filter { }
    //      .withLatestFrom(self.stationLists)
    
    
    //      .map { self.stationLists[$0] }
    //      .map { self.stationInteractor.createStation(station: $0) }
    //      .asDriver(onErrorJustReturn: ())
    
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchStationLists: fetchStationLists,
                  updateLocation: updateLocation,
                  locationForCameraMove: locationForCameraMove,
                  updateStation: updateStation,
                  updateCurrentLocation: updateCurrentLocation,
                  //                  showStationSearch: showStationSearch,
      //                  saveStation: saveStation,
      stationList: stationInteractor.stationList().asDriver(onErrorJustReturn: []))
  }
}
