//
//  BaseViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import SnapKit
import SwiftEntryKit

class BaseViewController: UIViewController {
  
  lazy var toastView: ToastView = {
    let view = ToastView()
    
    self.view.addSubview(view)
    view.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(view.statusMessage.snp.height).offset(36)
    }
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    bindViewModel()
  }
  
  deinit {
    DLog(String(describing: self))
  }
  
  func setupUI() {
    
  }
  
  func bindViewModel() {
    
  }
  
}
