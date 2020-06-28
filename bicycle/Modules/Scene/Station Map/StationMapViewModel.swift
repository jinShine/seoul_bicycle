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
    let didTapStationSearch: Observable<Void>
    let didTapLikeInMarkerInfo: Observable<(Station, Bool)>
  }
  
  struct Output {
    let locationGrantPermission: Driver<Bool>
    let fetchStationList: Driver<[Station]>
    let updateLocation: Driver<((Double?, Double?), Error?)>
    let locationForCameraMove: Driver<(Double, Double)>
    let updateStationList: Driver<[Station]>
    let updateCurrentLocation: Driver<Void>
    let showStationSearch: Driver<[Station]>
    let saveAndDeleteStation: Driver<[Station]>
    let syncLikeStation: Driver<Void>
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
    
    let stationListData = Observable<[Station]>
      .concat([fetchStations1, fetchStations2, fetchStations3])
      .catchErrorJustReturn([])
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .reduce([], accumulator: { $0 + $1 })
      .map {
        $0.map { [weak self] station -> Station in
          
          let distance = self?.getDistanceFrom(lat: Double(station.stationLatitude), lng: Double(station.stationLongitude))
          
          let likeStation = self?.stationInteractor.likeStations.first(where: { $0 == station })
          
          var stationTemp = station
          stationTemp.distance = distance
          stationTemp.like = likeStation == station ? true : false
          
          return stationTemp
        }
    }
    .do(onNext: {
      self.stationList.removeAll(keepingCapacity: true)
      self.stationList.append(contentsOf: $0) }
    )
    
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
      .flatMapLatest { stationListData }
      .asDriver(onErrorJustReturn: [])
    
    let updateCurrentLocation = input.didTapUpdateLocation
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    let showStationSearch = input.didTapStationSearch
      .filter { !self.stationList.isEmpty }
      .map { self.stationList }
      .asDriver(onErrorJustReturn: [])
    
    let saveAndDeleteStation = input.didTapLikeInMarkerInfo
      .map ({ (station, isSelected ) in
        if isSelected {
          var stationTemp = station
          stationTemp.like = true
          self.stationInteractor.createStation(station: stationTemp)
        } else {
          self.stationInteractor.delete(station: station)
        }
      })
      .flatMapLatest { _ in stationListData }
      .asDriver(onErrorJustReturn: [])
    
    let syncLikeStation = stationInteractor
      .likeStationList()
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchStationList: fetchStationList,
                  updateLocation: updateLocation,
                  locationForCameraMove: locationForCameraMove,
                  updateStationList: updateStationList,
                  updateCurrentLocation: updateCurrentLocation,
                  showStationSearch: showStationSearch,
                  saveAndDeleteStation: saveAndDeleteStation,
                  syncLikeStation: syncLikeStation)
  }
  
  private func getDistanceFrom(lat: Double?, lng: Double?) -> Double {
    return self.locationInteractor.currentDistacne(from: (lat, lng))
  }
}
