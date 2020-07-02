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
import RxGesture
import RAMAnimatedTabBarController
import SkyFloatingLabelTextField
import ActiveLabel

class SignInViewController: BaseViewController {
  
  //MARK: - Constant
  
  enum Constant {
    case naviBackground, logo, appTitle, close, id, password, signIn, signUp, desc
    
    var title: String {
      switch self {
      case .appTitle: return "따릉해"
      case .id: return "기존 따릉이 앱 아이디"
      case .password: return "비밀번호"
      case .signIn: return "로그인"
      case .signUp: return "회원가입"
      case .desc: return "따릉해는 SNS로그인을 지원하지 않습니다.\n기존 따릉이 아이디를 통해 로그인 하실 수 있습니다."
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
  
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.keyboardDismissMode = .onDrag
    scrollView.showsVerticalScrollIndicator = false
    scrollView.endEditing(true)
    return scrollView
  }()
  
  let contentView: UIView = {
    let view = UIView()
    return view
  }()
  
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
    label.textAlignment = .center
    label.font = AppTheme.font.custom(size: 20)
    return label
  }()
  
  let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(Constant.close.image, for: .normal)
    button.tintColor = AppTheme.color.white
    return button
  }()
  
  let idTextField: SkyFloatingLabelTextField = {
    let textField = SkyFloatingLabelTextField()
    textField.font = AppTheme.font.custom(size: 14)
    textField.placeholder = Constant.id.title
    textField.placeholderFont = AppTheme.font.custom(size: 14)
    textField.title = Constant.id.title
    textField.titleFont = AppTheme.font.custom(size: 14)
    textField.titleColor = AppTheme.color.subMain
    textField.textColor = AppTheme.color.blueMagenta
    textField.selectedTitleColor = AppTheme.color.subMain
    textField.selectedLineColor = AppTheme.color.lightGray
    textField.lineColor = AppTheme.color.lightGray
    return textField
  }()
  
  let pwTextField: SkyFloatingLabelTextField = {
    let textField = SkyFloatingLabelTextField()
    textField.isSecureTextEntry = true
    textField.font = AppTheme.font.custom(size: 14)
    textField.placeholder = Constant.password.title
    textField.placeholderFont = AppTheme.font.custom(size: 14)
    textField.title = Constant.password.title
    textField.titleFont = AppTheme.font.custom(size: 14)
    textField.titleColor = AppTheme.color.subMain
    textField.textColor = AppTheme.color.blueMagenta
    textField.selectedTitleColor = AppTheme.color.subMain
    textField.selectedLineColor = AppTheme.color.lightGray
    textField.lineColor = AppTheme.color.lightGray
    return textField
  }()
  
  let signInButton: UIButton = {
    let button = UIButton()
    button.setTitle(Constant.signIn.title, for: .normal)
    button.setTitleColor(AppTheme.color.white, for: .normal)
    button.titleLabel?.font = AppTheme.font.custom(size: 15)
    button.backgroundColor = AppTheme.color.main
    button.layer.cornerRadius = 8
    return button
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle(Constant.signUp.title, for: .normal)
    button.setTitleColor(AppTheme.color.blueMagenta, for: .normal)
    button.titleLabel?.font = AppTheme.font.custom(size: 15)
    return button
  }()
  
  let descLabel: ActiveLabel = {
    let label = ActiveLabel()
    label.textColor = AppTheme.color.blueMagenta
    label.textAlignment = .center
    label.font = AppTheme.font.custom(size: 12)
    label.numberOfLines = 0
    
    let customType = ActiveType.custom(pattern: "따릉이")
    label.customColor[customType] = AppTheme.color.subMain
    label.customSelectedColor[customType] = AppTheme.color.subMain
    label.enabledTypes = [customType]
    label.handleCustomTap(for: customType) { _ in
      if let url = URL(string: "https://www.bikeseoul.com/login.do") {
        UIApplication.shared.open(url)
      }
    }
    
    
    return label
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
  
  override func setupUI() {
    super.setupUI()
    
    setupDismissGesture()
    setupDescLabel()
    
    [scrollView].forEach { view.addSubview($0) }
    [contentView].forEach { scrollView.addSubview($0) }
    [navigationView, idTextField, pwTextField, signInButton, signUpButton, descLabel].forEach { contentView.addSubview($0) }
    [closeButton, logoImageView, appTitleLabel].forEach { navigationView.addSubview($0) }
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self.view)
    }
    
    contentView.snp.makeConstraints {
      $0.top.bottom.equalTo(self.scrollView)
      $0.left.right.equalTo(self.view)
      $0.width.equalTo(self.scrollView)
      $0.height.equalTo(self.scrollView)
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
      $0.centerX.equalTo(logoImageView)
    }
    
    idTextField.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(30)
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
    
    descLabel.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(signUpButton.snp.bottom).offset(30)
      $0.bottom.equalToSuperview().offset(-50)
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(signUpButton)
      $0.trailing.equalTo(signUpButton)
      $0.height.equalTo(80)
    }
  }

  override func bindViewModel() {
    super.bindViewModel()
    
    // Input
    
    AppNotificationCenter.keyboardHeight()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] height in
        guard let self = self else { return }
        if height > 0.0 {
          self.scrollView.setContentOffset(CGPoint(x: 0, y: height / 3), animated: true)
          self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        } else {
          self.scrollView.contentInset = .zero
        }
        
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
      })
      .disposed(by: rx.disposeBag)
    
    let dd = Observable.combineLatest(idTextField.rx.text.orEmpty.asObservable(), pwTextField.rx.text.orEmpty.asObservable())
    
    
    let input = SignInViewModel.Input(userInfo: dd)
    
    // Output
    
    let output = viewModel?.transform(input: input)
    
  }
  
  private func setupDescLabel() {
    let attrStr = NSMutableAttributedString(string: Constant.desc.title)
    let foundRange = attrStr.mutableString.range(of: "따릉이")
    attrStr.addAttributes([.link: "https://www.bikeseoul.com/login.do",
                           .underlineStyle: NSUnderlineStyle.single.rawValue,
                           .underlineColor: AppTheme.color.subMain], range: foundRange)
    descLabel.attributedText = attrStr
  }
}
