//
//  SignInViewController.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/01.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RAMAnimatedTabBarController
import SkyFloatingLabelTextField

class SignInViewController: BaseViewController {
  
  //MARK: - Constant
  
  enum Constant {
    case naviBackground, logo, appTitle, close, id, password, signIn, signUp
    
    var title: String {
      switch self {
      case .appTitle: return "따릉해"
      case .id: return "아이디"
      case .password: return "비밀번호"
      case .signIn: return "로그인"
      case .signUp: return "회원가입"
      default: return ""
      }
    }
    
    var image: UIImage? {
      switch self {
      case .naviBackground: return UIImage(named: "Header-Background")
      case .logo: return UIImage(named: "Icon-App")
      case .close: return UIImage(named: "Icon-Navi-Cancel")
      default: return nil
      }
    }
  }
  
  //MARK: - UI Properties

  let navigationView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Header-Background")
    return imageView
  }()
  
  let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Constant.logo.image
    return imageView
  }()
  
  let appTitleLabel: UILabel = {
    let label = UILabel()
    label.text = Constant.appTitle.title
    label.textColor = AppTheme.color.white
    label.font = AppTheme.font.custom(size: 24)
    return label
  }()
  
  let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(Constant.close.image, for: .normal)
    button.tintColor = AppTheme.color.white
    return button
  }()
  
  let idTextField: SkyFloatingLabelTextField = {
    let label = SkyFloatingLabelTextField()
    label.font = AppTheme.font.custom(size: 14)
    label.placeholder = Constant.id.title
    label.placeholderFont = AppTheme.font.custom(size: 14)
    label.title = Constant.id.title
    label.titleFont = AppTheme.font.custom(size: 14)
    label.titleColor = AppTheme.color.subMain
    label.textColor = AppTheme.color.blueMagenta
    label.selectedTitleColor = AppTheme.color.subMain
    label.selectedLineColor = AppTheme.color.lightGray
    label.lineColor = AppTheme.color.lightGray
    return label
  }()
  
  let pwTextField: SkyFloatingLabelTextField = {
    let label = SkyFloatingLabelTextField()
    label.isSecureTextEntry = true
    label.font = AppTheme.font.custom(size: 14)
    label.placeholder = Constant.password.title
    label.placeholderFont = AppTheme.font.custom(size: 14)
    label.title = Constant.password.title
    label.titleFont = AppTheme.font.custom(size: 14)
    label.titleColor = AppTheme.color.subMain
    label.textColor = AppTheme.color.blueMagenta
    label.selectedTitleColor = AppTheme.color.subMain
    label.selectedLineColor = AppTheme.color.lightGray
    label.lineColor = AppTheme.color.lightGray
    return label
  }()
  
  let signInButton: UIButton = {
    let button = UIButton()
    button.setTitle(Constant.signIn.title, for: .normal)
    button.setTitleColor(AppTheme.color.white, for: .normal)
    button.titleLabel?.font = AppTheme.font.custom(size: 15)
    button.backgroundColor = AppTheme.color.main
    button.layer.cornerRadius = 12
    return button
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle(Constant.signUp.title, for: .normal)
    button.setTitleColor(AppTheme.color.main, for: .normal)
    button.titleLabel?.font = AppTheme.font.custom(size: 15)
    return button
  }()
  
  //MARK: - Properties
  
  let viewModel: SignInViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? SignInViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  override func setupUI() {
    super.setupUI()
    
    [navigationView, idTextField, pwTextField, signInButton, signUpButton].forEach {
      view.addSubview($0)
    }
    [closeButton, logoImageView, appTitleLabel].forEach {
      navigationView.addSubview($0)
    }
    
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(268)
    }
    
    closeButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.hasTopNotch ? 44 + 34 : 24 + 34)
      $0.trailing.equalToSuperview().offset(-24)
      $0.size.equalTo(16)
    }
    
    logoImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(view.hasTopNotch ? 44 + 80 : 24 + 80)
      $0.leading.equalToSuperview().offset(36)
      $0.width.equalTo(60)
      $0.height.equalTo(69)
    }
    
    appTitleLabel.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(16)
      $0.leading.equalTo(logoImageView)
    }
    
    idTextField.snp.makeConstraints {
      $0.top.equalTo(appTitleLabel.snp.bottom).offset(50)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(1.25)
      $0.height.equalTo(50)
    }
    
    pwTextField.snp.makeConstraints {
      $0.top.equalTo(idTextField.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(1.25)
      $0.height.equalTo(50)
    }
    
    signInButton.snp.makeConstraints {
      $0.top.equalTo(pwTextField.snp.bottom).offset(24)
      $0.size.equalTo(pwTextField)
      $0.centerX.equalToSuperview()
    }
    
    signUpButton.snp.makeConstraints {
      $0.top.equalTo(signInButton.snp.bottom).offset(10)
      $0.size.equalTo(signInButton)
      $0.centerX.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    // Input
    
    let input = SignInViewModel.Input()
    
    // Output
    
    let output = viewModel?.transform(input: input)

  }
}
