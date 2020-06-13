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
    let fetchBicycleList: Driver<[Station]>
    let updateLocation: Driver<((Double?, Double?), Error?)>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  
  var stationLists: [Station] = []
  
  init(locationInteractor: LocationUseCase, seoulBicycleInteractor: SeoulBicycleUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulBicycleInteractor = seoulBicycleInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let locationGrantPermission = locationInteractor.start().asDriver(onErrorJustReturn: false)
    
    let fetchBicycleList = seoulBicycleInteractor
      .fetchBicycleList(start: 1, last: 1000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchBicycleList1 = seoulBicycleInteractor
      .fetchBicycleList(start: 1001, last: 2000)
      .map { $0.status.row }
      .asObservable()
    
    let fetchBicycleList2 = seoulBicycleInteractor
      .fetchBicycleList(start: 2001, last: 3000)
      .map { $0.status.row }
      .asObservable()
    
    let dd = Observable<[Station]>.concat([
      fetchBicycleList,
      fetchBicycleList1,
      fetchBicycleList2
      ]).asDriver(onErrorJustReturn: [])

    
    let updateLocation = locationInteractor
      .fetchLocation()
      .map { (location, error) in
        return ((location?.coordinate.latitude, location?.coordinate.longitude), error)
      }
      .asDriver(onErrorJustReturn: ((37.5666805, 126.9784147), nil))
    
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchBicycleList: dd,
                  updateLocation: updateLocation)
  }
}
