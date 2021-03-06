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

class StationMapViewModel: BaseViewModel, ViewModelType, AppGlobalRepositoryType {
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let didTapUpdateStation: Observable<Void>
    let didTapMoveLocation: Observable<Void>
    let didTapStationSearch: Observable<Void>
    let didTapLikeInMarkerInfo: Observable<(Bool, String)>
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
    let updatedDate: Driver<String>
  }
  
  let locationInteractor: LocationUseCase
  let seoulOpenAPIInteractor: SeoulOpenAPIUseCase
  let stationInteractor: StationUseCase
  var stationList: [Station] = []
  var currentCooredinate = BehaviorSubject<(Double, Double)>(value: (0.0, 0.0))
  
  init(locationInteractor: LocationUseCase,
       seoulOpenAPIInteractor: SeoulOpenAPIUseCase,
       stationInteractor: StationUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulOpenAPIInteractor = seoulOpenAPIInteractor
    self.stationInteractor = stationInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let onUpdatedDate = appConstant.repository.updatedDate
    
    let locationGrantPermission = locationInteractor
      .start()
      .asDriver(onErrorJustReturn: false)

    let stationListData = Observable.combineLatest(seoulOpenAPIInteractor.fetchStations(), stationInteractor.readLikeStation())
      .map { (allStation, likedStation) in
        allStation.map { station in
          self.remakeModel(for: station, with: likedStation)
        }
      }
      .do(onNext: { self.update(with: $0) })
      .do(onNext: { self.appConstant.repository.stationList.onNext($0) })

    let fetchStationList = input.viewWillAppear
      .do(onNext: { _ in onUpdatedDate.onNext(Date().current) })
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .flatMap { stationListData }
      .asDriver(onErrorJustReturn: [])
    
    let updateLocation = locationInteractor
      .fetchLocation()
      .map { [weak self] (location, error) -> ((Double?, Double?), Error?) in
        let lat = location?.coordinate.latitude ?? 0.0
        let lng = location?.coordinate.longitude ?? 0.0
        self?.currentCooredinate.onNext((lat, lng))
        return ((lat, lng), error)
      }.asDriver(onErrorJustReturn: ((37.5666805, 126.9784147), nil))

    let updateLocationForCameraMove = locationInteractor
      .currentLocation()
      .map { ($0 ?? 37.5666805 , $1 ?? 126.9784147) }
      .take(1)
      .asDriver(onErrorJustReturn: ((37.5666805, 126.9784147)))
    
    let updateStationList = input.didTapUpdateStation
      .do(onNext: { _ in onUpdatedDate.onNext(Date().current) })
      .flatMapLatest { stationListData }
      .asDriver(onErrorJustReturn: [])
    
    let updateCurrentLocation = input.didTapMoveLocation
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    let showStationSearch = input.didTapStationSearch
      .filter { !self.stationList.isEmpty }
      .map { self.stationList }
      .asDriver(onErrorJustReturn: [])
    
    let saveAndDeleteStation = input.didTapLikeInMarkerInfo
      .map { (isSelected, name) in
        let station = self.stationList.first { $0.stationName == name } ?? Station()
        
        if isSelected {
          var stationTemp = station
          stationTemp.like = true
          self.stationInteractor.createStation(station: stationTemp)
        } else {
          self.stationInteractor.delete(station: station)
        }
      }
      .flatMapLatest { _ in stationListData }
      .asDriver(onErrorJustReturn: [])
        
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchStationList: fetchStationList,
                  updateLocation: updateLocation,
                  locationForCameraMove: updateLocationForCameraMove,
                  updateStationList: updateStationList,
                  updateCurrentLocation: updateCurrentLocation,
                  showStationSearch: showStationSearch,
                  saveAndDeleteStation: saveAndDeleteStation,
                  updatedDate: onUpdatedDate.asDriver(onErrorJustReturn: ""))
  }
  
}

//MARK:- Action Methods

extension StationMapViewModel {
  
  private func getDistanceFrom(lat: Double?, lng: Double?) -> Double {
    return self.locationInteractor.currentDistacne(from: (lat, lng))
  }
  
  private func remakeModel(for station: Station, with likes: [Station]) -> Station {
  
    let distance = self.getDistanceFrom(lat: Double(station.stationLatitude), lng: Double(station.stationLongitude))
    let likedStation = likes.first(where: { $0 == station })
    
    var stationTemp = station
    stationTemp.distance = distance
    stationTemp.like = likedStation == station ? true : false
    return stationTemp
  }

  private func update(with stations: [Station]) {
    stationList.removeAll(keepingCapacity: true)
    stationList.append(contentsOf: stations)
  }
  
}
