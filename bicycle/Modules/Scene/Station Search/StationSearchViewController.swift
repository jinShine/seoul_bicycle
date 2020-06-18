//
//  StationSearchViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/18.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

class StationSearchViewController: BaseViewController {
  
  //MARK: - Constant
  
  enum Constant {
    case search, cancel
    
    var title: String {
      switch self {
      case .search: return "대여소 검색"
      default: return ""
      }
    }
    
    var image: UIImage? {
      switch self {
      case .cancel: return UIImage(named: "Icon-Cancel")
      default: return nil
      }
    }
  }
  
  //MARK: - Properties
  
  let searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constant.search.title
    textField.font = AppTheme.font.custom(size: 15)
    textField.textColor = AppTheme.color.blueMagenta
    return textField
  }()
  
  let dismissButton: UIButton = {
    let button = UIButton()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(Constant.cancel.image, for: .normal)
    button.backgroundColor = AppTheme.color.white
    button.tintColor = AppTheme.color.blueMagenta
    return button
  }()
  
  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = AppTheme.color.main
    return view
  }()
  
  let viewModel: StationSearchViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? StationSearchViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    animateView()
    searchTextField.becomeFirstResponder()
  }
  
  deinit {
    
  }
  
  override func setupUI() {
    super.setupUI()
    
    searchTextField.text = ""
    
    [searchTextField, dismissButton, lineView].forEach { view.addSubview($0) }
    
    searchTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.topNotchHeight + 12)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalTo(dismissButton.snp.leading).offset(-16)
      $0.height.equalTo(54)
    }
    
    dismissButton.snp.makeConstraints {
      $0.centerY.equalTo(searchTextField)
      $0.trailing.equalToSuperview().offset(-5)
      $0.size.equalTo(searchTextField.snp.height)
    }
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom)
      $0.leading.equalToSuperview().offset(view.center.x)
      $0.trailing.equalToSuperview().offset(-view.center.x)
      $0.height.equalTo(1)
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    // Input
    let input = StationSearchViewModel.Input(didTapDismiss: dismissButton.rx.tap.asObservable())
    
    // Output
    let output = viewModel?.transform(input: input)
    
    output?.dismiss.drive(onNext: { _ in
      self.navigator.dismiss(sender: self, animated: true)
    }).disposed(by: rx.disposeBag)
    
    
  }
  
  //MARK:- Methods
  
  private func animateView() {
    
    // line view
    self.lineView.snp.updateConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }
    
    UIView.animate(withDuration: 0.35) {
      self.view.layoutIfNeeded()
    }
  }
}



