//
//  BaseViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwiftEntryKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {

  private lazy var activityIndicator: NVActivityIndicatorView = {
    let indicatorView = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: AppTheme.color.main)
    self.view.addSubview(indicatorView)
    indicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(30)
    }
    return indicatorView
  }()

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
  
  func loadingStart() {
    activityIndicator.startAnimating()
  }
  
  func loadingStop() {
    activityIndicator.stopAnimating()
  }
}
