//
//  LocationTrackingViewModel.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

final class LocationTrackingViewModel: BindViewModelType {
  
  //MARK: - Constant
  
  struct Constant {
    static let pagePerCount = 30
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewWillAppear
  }
  
  enum Action {
    case viewWillAppearAction
  }
  
  enum State {
    case viewWillAppearState(latitude: Double, longitude: Double)
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()

  
  
  
  //MARK: - Properties
  var locationUseCase: LocationUseCase
  
  //MARK: - Initialize
  init(locationUseCase: LocationUseCase) {
    self.locationUseCase = locationUseCase
    self.bind()
  }
  
  
  //MARK: - Unidirection Action
  
  func toAction(from command: Command) -> Observable<Action> {
    switch command {
    case .viewWillAppear:
      return Observable<Action>.just(.viewWillAppearAction)
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewWillAppearAction:
      return locationUseCase.locationCoordinate
        .flatMap { coordinate in
          return Observable<State>.just(.viewWillAppearState(latitude: coordinate.latitude,
                                                             longitude: coordinate.longitude))
        }
        .retry(2)
        .catchErrorJustReturn(.viewWillAppearState(latitude: 0, longitude: 0))
    }
  }
  
}

//MARK: - Method Handler
extension LocationTrackingViewModel {


}
