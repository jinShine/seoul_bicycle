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

class FavoriteViewModel: BaseViewModel, ViewModelType, AppGlobalRepositoryType {
  
  struct Input {
    let trigger: Observable<Void>
    let refresh: Observable<Void>
    let didTapRefresh: Observable<Void>
  }
  
  struct Output {
    let likeStationList: Observable<[SectionStation]>
    let isLoading: Driver<Bool>
    let isEmpty: Driver<Bool>
    let updatedDate: Driver<String>
  }
  
  let stationInteractor: StationUseCase
  
  init(stationInteractor: StationUseCase) {
    self.stationInteractor = stationInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let onEmptyView = PublishSubject<Bool>()
    let onUpdatedDate = appConstant.repository.updatedDate
    let onLoading = PublishSubject<Bool>()
    let isLoading = onLoading.asDriver(onErrorJustReturn: false)
    
    let likeStationList = Observable<Void>
      .merge([input.trigger, input.refresh, input.didTapRefresh])
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .flatMap { self.appConstant.repository.stationList }
      .map { $0.filter { $0.like == true} }
      .do(onNext: { $0.isEmpty ? onEmptyView.onNext(true) : onEmptyView.onNext(false) })
      .do(onNext: { _ in onUpdatedDate.onNext(Date().current)})
      .do(onNext: { _ in onLoading.onNext(true) })
      .map { [SectionStation(model: 0, items: $0)] }
      .asObservable()
    
    return Output(likeStationList: likeStationList,
                  isLoading: isLoading,
                  isEmpty: onEmptyView.asDriver(onErrorJustReturn: false),
                  updatedDate: onUpdatedDate.asDriver(onErrorJustReturn: ""))
  }
}
