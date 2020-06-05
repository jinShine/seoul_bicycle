//
//  HomeTabBarController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/04.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RAMAnimatedTabBarController
import RxViewController
import NSObject_Rx

enum HomeTabBarItem: Int {
  case favorite, stationMap, userInfo
  
  var animation: RAMItemAnimation {
      var animation: RAMItemAnimation
      switch self {
      case .favorite: animation = RAMFlipLeftTransitionItemAnimations()
      case .stationMap: animation = RAMBounceAnimation()
      case .userInfo: animation = RAMRightRotationAnimation()
      }
    
      return animation
  }
  
  var image: UIImage? {
    switch self {
    case .favorite: return UIImage(named: "Icon-TabBar-Star")
    case .stationMap: return UIImage(named: "Icon-TabBar-Cycle")
    case .userInfo: return UIImage(named: "Icon-TabBar-User")
    }
  }
  
  private func controller(viewModel: BaseViewModel, navigator: Navigator) -> UIViewController {
    switch self {
    case .favorite:
      let vc = FavoriteViewController(viewModel: viewModel, navigator: navigator)
      return BaseNavigationController(rootViewController: vc)
    case .stationMap:
      let vc = StationMapViewController(viewModel: viewModel, navigator: navigator)
      return BaseNavigationController(rootViewController: vc)
    case .userInfo:
      let vc = UserInfoViewController(viewModel: viewModel, navigator: navigator)
      return BaseNavigationController(rootViewController: vc)
    }
  }
  
  func getController(viewModel: BaseViewModel, navigator: Navigator) -> UIViewController {
    let vc = controller(viewModel: viewModel, navigator: navigator)
    let item = RAMAnimatedTabBarItem(title: nil, image: image, tag: rawValue)
    item.animation = animation
    vc.tabBarItem = item
    
    return vc
  }
}

class HomeTabBarController: RAMAnimatedTabBarController {
  
  let viewModel: HomeTabBarViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? HomeTabBarViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    bind()
  }
  
  func setupUI() {
    
  }
  
  func bind() {
    // Input
    let input = HomeTabBarViewModel.Input(setupTabBarTrigger: rx.viewWillAppear.mapToVoid())
    
    // Output
    let output = viewModel?.transform(input: input)
    
    output?.tabBarItems.drive(onNext: { [weak self] tabBarItems in
      if let self = self {
        let controllers = tabBarItems.map {
          $0.getController(viewModel: self.viewModel!.viewModel(for: $0), navigator: self.navigator)
        }
        self.setViewControllers(controllers, animated: false)
      }
    }).disposed(by: rx.disposeBag)
    
  }
  
}
