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
  case signin
  case signup
  case findPassword
  case createSpcae
  case locationTracking
}


extension Navigator {
  
  var viewController: UIViewController {
    switch self {
    case .login:
      let viewModel = LoginViewModel(signinUseCase: SignInInteractor())
      let viewController = LoginViewController(viewModel: viewModel)
      let rootViewController = UINavigationController(rootViewController: viewController)
      return rootViewController
    case .signin:
      let viewModel = SignInViewModel(signinUseCase: SignInInteractor())
      let viewController = UIStoryboard.create(SignInViewController.self, name: "Login", bundle: nil, identifier: "SignInViewController")
      viewController.viewModel = viewModel
      return viewController
    case .signup:
      let viewModel = SignUpViewModel(signupUseCase: SignUpInteractor())
      let viewController = UIStoryboard.create(SignUpViewController.self, name: "Login", bundle: nil, identifier: "SignUpViewController")
      viewController.viewModel = viewModel
      return viewController
    case .findPassword:
      let viewModel = FindPasswordViewModel(findPasswordUseCase: FindPasswordInteractor())
      let viewController = UIStoryboard.create(FindPasswordViewController.self, name: "Login", bundle: nil, identifier: "FindPasswordViewController")
      viewController.viewModel = viewModel
      return viewController
    case .createSpcae:
      let viewModel = CreateSpaceViewModel()
      let viewController = UIStoryboard.create(CreateSpaceViewController.self, name: "CreateSpace", bundle: nil, identifier: "CreateSpaceViewController")
      viewController.viewModel = viewModel
      return viewController
    case .locationTracking:
      let viewModel = LocationTrackingViewModel(locationUseCase: LocationInteractor())
      let viewController = LocationTrackingViewController(viewModel: viewModel)
      return viewController
      
    }
  }
}
