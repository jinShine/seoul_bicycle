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
    let fetchBicycleList: Driver<Station>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  
  init(locationInteractor: LocationUseCase, seoulBicycleInteractor: SeoulBicycleUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulBicycleInteractor = seoulBicycleInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let locationGrantPermission = locationInteractor.start().asDriver(onErrorJustReturn: false)
    
    let fetchBicycleList = seoulBicycleInteractor.fetchBicycleList(start: 1, last: 100)
      .map { response in
        let result = try JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
        }
    }
    
    print(fetchBicycleList)
    
    return Output(locationGrantPermission: locationGrantPermission)
  }
}
