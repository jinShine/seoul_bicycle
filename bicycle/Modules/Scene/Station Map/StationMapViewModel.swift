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
    let locationGrantTrigger: Observable<Void>
  }
  
  struct Output {
    let locationGrantPermission: Driver<Bool>
    let fetchBicycleList: Driver<[Station]>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  
  init(locationInteractor: LocationUseCase, seoulBicycleInteractor: SeoulBicycleUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulBicycleInteractor = seoulBicycleInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let locationGrantPermission = locationInteractor.start().asDriver(onErrorJustReturn: false)
    
    let fetchBicycleList = seoulBicycleInteractor
      .fetchBicycleList(start: 1, last: 1000)
      .map { $0.status.row }
      .asDriver(onErrorJustReturn: [])
    
    return Output(locationGrantPermission: locationGrantPermission,
                  fetchBicycleList: fetchBicycleList)
  }
}
