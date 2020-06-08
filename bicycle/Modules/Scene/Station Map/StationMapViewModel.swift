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
    let locationGrantPermission: Driver<Void>
  }
  
  let locationInteractor: LocationUseCase
  
  init(locationInteractor: LocationUseCase) {
    self.locationInteractor = locationInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let locationGrantPermission = locationInteractor.start().asDriver(onErrorJustReturn: ())
    
    return Output(locationGrantPermission: locationGrantPermission)
  }
}
