//
//  FavoriteViewModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteViewModel: BaseViewModel, ViewModelType {
  
  struct Input {
    let trigger: Observable<Void>
    let refresh: Observable<Void>
  }
  
  struct Output {
    let likeStationList: Observable<[SectionStation]>
    let isLoading: Driver<Bool>
  }
  
  let stationInteractor: StationUseCase
  
  init(stationInteractor: StationUseCase) {
    self.stationInteractor = stationInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let onLoading = PublishSubject<Bool>()
    
    let likeStationList = Observable<Void>
      .merge([input.trigger, input.refresh])
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .do(onNext: { _ in onLoading.onNext(true) })
      .flatMap { self.stationInteractor.likeStationList() }
      .map { [SectionStation(model: 0, items: $0)] }
      .asObservable()
    
    

    return Output(likeStationList: likeStationList,
                  isLoading: onLoading.asDriver(onErrorJustReturn: false))
  }
}
