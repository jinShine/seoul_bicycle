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
    let fetchStationListTrigger: Observable<Void>
    let didTapUpdateStation: Observable<Void>
    let didTapUpdateLocation: Observable<Void>
    let didTapStationContainer: Observable<Void>
    let didTapLikeInMarkerInfo: Observable<(Int, Bool)>
  }
  
  struct Output {
    let locationGrantPermission: Driver<Bool>
    let fetchStationList: Driver<[Station]>
    let updateLocation: Driver<((Double?, Double?), Error?)>
    let locationForCameraMove: Driver<(Double, Double)>
    let updateStationList: Driver<[Station]>
    let updateCurrentLocation: Driver<Void>
    //    let showStationSearch: Driver<[Station]>
    //    let fetchStationList: Driver<[Station]>
    let saveAndDeleteStation: Driver<Void>
    //    let deleteStation: Driver<Void>
    let stationList: Driver<[Station]>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  let stationInteractor: StationUseCase
  
  var stationList: [Station] = []
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
      .start()
      .asDriver(onErrorJustReturn: false)
    
    let fetchStations1 = seoulBicycleInteractor
      .fetchBicycleList(start: 1, last: 1000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchStations2 = seoulBicycleInteractor
      .fetchBicycleList(start: 1001, last: 2000)
      .map { $0.status.row }
      .asObservable()
    
    // 2000개 이상 Station이 생겼는지 확인해보기~
    let fetchStations3 = seoulBicycleInteractor
      .fetchBicycleList(start: 2001, last: 3000)
      .map { $0.status.row }
      .asObservable()
    
    let stationListData = Observable<[Station]>.concat([
      fetchStations1,
      fetchStations2,
      fetchStations3
    ]).catchErrorJustReturn([])
      .reduce([], accumulator: { $0 + $1 })
      .map {
        $0.enumerated().map { [weak self] (index, station) -> Station in
          
          let distance = self?.locationInteractor.currentDistacne(
            from: (Double(station.stationLatitude),
                   Double(station.stationLongitude))
          )
          
          let likeIndex = self?.stationInteractor.stations
            .compactMap { $0.id }
            .filter { $0 == index }
            .first
          
          if likeIndex == index {
            return Station(id: index,
                           rackTotCnt: station.rackTotCnt,
                           stationName: station.stationName,
                           parkingBikeTotCnt: station.parkingBikeTotCnt,
                           shared: station.shared,
                           stationLatitude: station.stationLatitude,
                           stationLongitude: station.stationLongitude,
                           stationId: station.stationId,
                           distacne: distance,
                           like: true)
          } else {
            return Station(id: index,
                           rackTotCnt: station.rackTotCnt,
                           stationName: station.stationName,
                           parkingBikeTotCnt: station.parkingBikeTotCnt,
                           shared: station.shared,
                           stationLatitude: station.stationLatitude,
                           stationLongitude: station.stationLongitude,
                           stationId: station.stationId,
                           distacne: distance,
                           like: false)
          }
        }
    }.do(onNext: { self.stationList.append(contentsOf: $0) })
    
    let fetchStationList = input.fetchStationListTrigger
      .flatMap { stationListData }
      .asDriver(onErrorJustReturn: [])
    
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
    
    let updateStationList = input.didTapUpdateStation
      .flatMap { stationListData }
      .asDriver(onErrorJustReturn: [])
    
    let updateCurrentLocation = input.didTapUpdateLocation
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    let saveAndDeleteStation = input.didTapLikeInMarkerInfo
      .map { (tag, isSelected) in
        return (isSelected, self.stationList[tag])
      }
      .map ({ (isSelected, station) in
        if isSelected {
          self.stationInteractor.createStation(station: station)
        } else {
          self.stationInteractor.delete(station: station)
        }
      }))
      .asDriver(onErrorJustReturn: ())
    
    
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchStationList: fetchStationList,
                  updateLocation: updateLocation,
                  locationForCameraMove: locationForCameraMove,
                  updateStationList: updateStationList,
                  updateCurrentLocation: updateCurrentLocation,
                  //                  showStationSearch: showStationSearch,
      saveAndDeleteStation: saveAndDeleteStation,
      //                        deleteStation: deleteStation,
      stationList: stationInteractor.stationList().asDriver(onErrorJustReturn: []))
  }
}
