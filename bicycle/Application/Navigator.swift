//
//  Navigator.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/04.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class Navigator {
  
  enum Scene {
    case tabs(viewModel: HomeTabBarViewModel)
    case favorite(viewModel: FavoriteViewModel)
    case stationMap(viewModel: StationMapViewModel)
    case userInfo(viewModel: UserInfoViewModel)
  }
  
  func navigate(to scene: Scene) -> UIViewController {
    switch scene {
    case .tabs(let viewModel):
      let rootVC = HomeTabBarController(viewModel: viewModel, navigator: self)
      return rootVC
    case .favorite(let viewModel): return FavoriteViewController(viewModel: viewModel, navigator: self)
    case .stationMap(let viewModel): return StationMapViewController(viewModel: viewModel, navigator: self)
    case .userInfo(let viewModel): return StationMapViewController(viewModel: viewModel, navigator: self)
    }
  }
}

extension Navigator {
  
  static let `default` = Navigator()
}
