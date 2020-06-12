//
//  HomeTabBarViewModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeTabBarViewModel: BaseViewModel, ViewModelType {
  
  struct Input {
    let setupTabBarTrigger: Observable<Void>
  }
  
  struct Output {
    let tabBarItems: Driver<[HomeTabBarItem]>
  }
  
  func transform(input: Input) -> Output {
    
    let tabBarItems = loggedIn.map { (loggedIn) -> [HomeTabBarItem] in
      if loggedIn {
        return [.favorite, .stationMap, .userInfo]
      } else {
        // 나중에 변경
        return [.favorite, .stationMap, .userInfo]
      }
    }.asDriver(onErrorJustReturn: [])
    
    
    return Output(tabBarItems: tabBarItems)
  }
  
  func viewModel(for tabBarItem: HomeTabBarItem) -> BaseViewModel {
    switch tabBarItem {
    case .favorite: return FavoriteViewModel()
    case .stationMap:
      return StationMapViewModel(
        locationInteractor: LocationInteractor(locationManager: LocationManager()),
        seoulBicycleInteractor: SeoulBicycleInteractor(network: NetworkService())
      )
    case .userInfo: return UserInfoViewModel()
    }
  }
}
