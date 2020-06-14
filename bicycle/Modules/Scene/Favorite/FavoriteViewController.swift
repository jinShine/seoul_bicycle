//
//  FavoriteViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: BaseViewController {
  
  let button1 = UIButton()
  
  let viewModel: BaseViewModel
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Favorite")
    
    view.addSubview(button1)
    button1.setTitle("123", for: .normal)
    button1.setTitleColor(.black, for: .normal)
    
    button1.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    button1.rx.tap.subscribe(onNext: { _ in
      print(12312312312312312)
    }).disposed(by: rx.disposeBag)
  }

}
