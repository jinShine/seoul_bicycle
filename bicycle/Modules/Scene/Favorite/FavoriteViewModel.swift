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
    let didTapLike: Observable<Station>
  }
  
  struct Output {
    let likeStationList: Observable<[SectionStation]>
    let isLoading: Driver<Bool>
    let isEmpty: Driver<Bool>
    let updatedDate: Driver<String>
    let removeLike: Driver<Void>
  }
  
  let locationInteractor: LocationUseCase
  let seoulBicycleInteractor: SeoulBicycleUseCase
  let stationInteractor: StationUseCase
  
  init(locationInteractor: LocationUseCase,
       seoulBicycleInteractor: SeoulBicycleUseCase,
       stationInteractor: StationUseCase) {
    self.locationInteractor = locationInteractor
    self.seoulBicycleInteractor = seoulBicycleInteractor
    self.stationInteractor = stationInteractor
  }
  
  func transform(input: Input) -> Output {
    
    let onEmptyView = PublishSubject<Bool>()
    let onUpdatedDate = appConstant.repository.updatedDate
    let onLoading = PublishSubject<Bool>()
    let isLoading = onLoading.asDriver(onErrorJustReturn: false)
    
    let stationListData = Observable.combineLatest(seoulBicycleInteractor.fetchStations(), stationInteractor.readLikeStation())
      .map { (allStation, likedStation) in
        allStation
          .map { station in
            self.remakeModel(for: station, with: likedStation)
          }.filter {$0.like == true }
      }

    let likeStationList = Observable<Void>
      .merge([input.trigger, input.refresh, input.didTapRefresh])
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .do(onNext: { _ in onLoading.onNext(true) })
      .flatMap { stationListData }
      .do(onNext: { _ in onLoading.onNext(false) })
      .do(onNext: { $0.isEmpty ? onEmptyView.onNext(true) : onEmptyView.onNext(false) })
      .do(onNext: { _ in onUpdatedDate.onNext(Date().current)})
      .map { [SectionStation(model: 0, items: $0)] }
      .asObservable()
    
    let removeLike = input.didTapLike
      .flatMap { self.stationInteractor.delete(station: $0) }
      .flatMapLatest { _ in stationListData }
      .mapToVoid()
      .asDriver(onErrorJustReturn: ())

    return Output(likeStationList: likeStationList,
                  isLoading: isLoading,
                  isEmpty: onEmptyView.asDriver(onErrorJustReturn: false),
                  updatedDate: onUpdatedDate.asDriver(onErrorJustReturn: ""),
                  removeLike: removeLike)
  }
}

//MARK:- Action Methods

extension FavoriteViewModel {
  
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
  
}
