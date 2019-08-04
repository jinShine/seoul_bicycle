//
//  BaseViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  
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
    
  }
  
}
