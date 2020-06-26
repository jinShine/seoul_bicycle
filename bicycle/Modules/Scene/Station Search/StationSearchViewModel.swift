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
    let searchQuery: Observable<String>
    let didTapDismiss: Observable<Void>
  }
  
  struct Output {
    let searchedStation: Observable<[SectionStation]>
    let dismiss: Driver<Void>
  }
  
  let stationLists: Observable<[SectionStation]>
  
  init(stationLists: Observable<[SectionStation]>) {
    self.stationLists = stationLists
  }
  
  func transform(input: Input) -> Output {
    
    let searchedStation = Observable<[SectionStation]>
      .combineLatest(stationLists, input.searchQuery) { (list, query) in
        return list.map {
          let station = $0.items.filter {
            $0.stationName.contains(query)
          }
          
          return SectionStation(model: 0, items: station)
        }
    }
    
    let dismisss = input.didTapDismiss.mapToVoid()
      .asDriver(onErrorJustReturn: ())
    
    return Output(searchedStation: searchedStation,
                  dismiss: dismisss)
  }
}
