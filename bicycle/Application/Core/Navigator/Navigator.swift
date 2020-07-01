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
    case stationSearch(viewModel: StationSearchViewModel)
    case signIn(viewModel: SignInViewModel)
  }
  
  func get(for scene: Scene) -> UIViewController {
    switch scene {
    case .tabs(let viewModel):
      let rootVC = HomeTabBarController(viewModel: viewModel, navigator: self)
      return rootVC
    case .favorite(let viewModel): return FavoriteViewController(viewModel: viewModel, navigator: self)
    case .stationMap(let viewModel): return StationMapViewController(viewModel: viewModel, navigator: self)
    case .userInfo(let viewModel): return StationMapViewController(viewModel: viewModel, navigator: self)
    case .stationSearch(let viewModel): return StationSearchViewController(viewModel: viewModel, navigator: self)
    case .signIn(let viewModel): return SignInViewController(viewModel: viewModel, navigator: self)
    }
  }
}

extension Navigator {
  
  static let `default` = Navigator()
}

//MARK:- Transition
extension Navigator: Transitionable {

  func pop(sender: UIViewController?, toRoot: Bool = false, animated: Bool) {
    if toRoot {
      sender?.navigationController?.popToRootViewController(animated: animated)
    } else {
      sender?.navigationController?.popViewController(animated: animated)
    }
  }

  func dismiss(sender: UIViewController,
               animated: Bool,
               completion: (() -> Void)? = nil) {
    sender.dismiss(animated: animated, completion: completion)
  }

  func show(scene: Scene,
            sender: UIViewController?,
            animated: Bool,
            completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      let vc = self.get(for: scene)
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .fullScreen
      sender?.present(vc, animated: true, completion: completion)
    }
  }

  func push(scene: Scene,
            sender: UINavigationController?,
            animated: Bool) {
    sender?.pushViewController(get(for: scene), animated: animated)
  }

}
