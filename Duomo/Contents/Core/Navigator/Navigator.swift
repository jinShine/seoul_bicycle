//
//  Navigator.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit

enum Navigator {
  case locationTracking
}


extension Navigator {
  
  var viewController: UIViewController {
    switch self {
    case .locationTracking:
      let viewModel = LocationTrackingViewModel(locationUseCase: LocationInteractor())
      let viewController = LocationTrackingViewController(viewModel: viewModel)
      return viewController
    }
  }
}
