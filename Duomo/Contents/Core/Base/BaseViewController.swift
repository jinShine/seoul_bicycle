//
//  BaseViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView

class BaseViewController: UIViewController {
  
  struct Constant {
    static let activityIndicatorSize = CGSize(width: 36, height: 36)
  }
  
  var activityIndicator: NVActivityIndicatorView!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit {
    print("DEINIT: \(String(describing: self))")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
  }
  
}

extension BaseViewController {
  
  private func setupUI() {
    
    //ActivityIndicator
    let point = CGPoint(x: view.center.x - (Constant.activityIndicatorSize.width / 2),
                        y: view.center.y - (Constant.activityIndicatorSize.height / 2))
    
    activityIndicator = NVActivityIndicatorView(frame: CGRect(origin: point, size: Constant.activityIndicatorSize),
                                                type: NVActivityIndicatorType.ballPulseSync, color: .red, padding: 0)
    self.view.addSubview(activityIndicator)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
