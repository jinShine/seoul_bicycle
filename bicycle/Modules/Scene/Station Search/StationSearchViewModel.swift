//
//  StationSearchViewModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/18.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StationSearchViewModel: BaseViewModel, ViewModelType {
  
  struct Input {
    let didTapDismiss: Observable<Void>
  }
  
  struct Output {
    let dismiss: Driver<Void>
  }
  
  let stationLists: [Station]
  
  init(stationLists: [Station]) {
    self.stationLists = stationLists
  }
  
  func transform(input: Input) -> Output {

    let dismisss = input.didTapDismiss.mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    return Output(dismiss: dismisss)
  }
}
