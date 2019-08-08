//
//  Navigator.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit

enum Navigator {
  case login
  case signup
  case locationTracking
}


extension Navigator {
  
  var viewController: UIViewController {
    switch self {
    case .login:
      let viewModel = LoginViewModel(loginUseCase: LoginInteractor())
      let viewController = LoginViewController(viewModel: viewModel)
      let rootViewController = UINavigationController(rootViewController: viewController)
      return rootViewController
    case .signup:
      let viewModel = SignUpViewModel(signupUseCase: SignUpInteractor())
      let viewController = UIStoryboard.create(SignUpViewController.self, name: "Login", bundle: nil, identifier: "SignUpViewController")
      viewController.viewModel = viewModel
      return viewController
    case .locationTracking:
      let viewModel = LocationTrackingViewModel(locationUseCase: LocationInteractor())
      let viewController = LocationTrackingViewController(viewModel: viewModel)
      return viewController
    }
  }
}
