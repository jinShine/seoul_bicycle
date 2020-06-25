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
import RxDataSources

class StationSearchViewModel: BaseViewModel, ViewModelType {
  
  struct Input {
    let trigger: Observable<Void>
    let didTapDismiss: Observable<Void>
  }
  
  struct Output {
    let fetchStationList: Observable<[SectionStation]>
    let dismiss: Driver<Void>
  }
  
  let stationLists: Observable<[SectionStation]>
  
  init(stationLists: Observable<[SectionStation]>) {
    self.stationLists = stationLists
  }
  
  func transform(input: Input) -> Output {
    
    let fetchStationList = stationLists

    let dismisss = input.didTapDismiss.mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    return Output(fetchStationList: fetchStationList,
                  dismiss: dismisss)
  }
}
