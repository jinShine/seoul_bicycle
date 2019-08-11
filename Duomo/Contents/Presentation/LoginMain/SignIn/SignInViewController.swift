//
//  SignInViewController.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa


class SignInViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let cornerRadius: CGFloat = 5
    static let buttonHeight: CGFloat = 60
    static let safeAreaBottom: CGFloat = 34
  }
  
  
  //MARK: - UI Properties
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var fieldContainer: UIView!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var findPasswordButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var signupHeightConstraint: NSLayoutConstraint!
  
  
  
  
  //MARK: - Properties
  typealias ViewModel = SignInViewModel
  var disposeBag = DisposeBag()
  
  
  
  init(viewModel: ViewModel) {
    defer {
      self.viewModel = viewModel
    }
    super.init()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismissKeyboard()
  }
  
}

//MARK: - Bind
extension SignInViewController {
  
  //OUTPUT
  func command(viewModel: ViewModel) {
    
    let obViewDidLoad = rx.viewDidLoad
      .map { _ in ViewModel.Command.viewDidLoad }
    
    
    let obEmailField = emailField.rx.text.orEmpty
    let obPasswordField = passwordField.rx.text.orEmpty
    let obContents = Observable.combineLatest([obEmailField, obPasswordField])

    let obDidTapLogin = loginButton.rx.tap
      .withLatestFrom(obContents)
      .map { ViewModel.Command.didTapLogin(email: $0[0], password: $0[1]) }
    
    let obDidTapSignup = signupButton.rx.tap
      .throttle(2.0, scheduler: MainScheduler.instance)
      .map { ViewModel.Command.didTapSignup }
    
    let obValidateField = obContents.map {
      ViewModel.Command.validateField(email: $0[0], password: $0[1])
    }

    let obDidTapFindPW = findPasswordButton.rx.tap
      .map { _ in ViewModel.Command.didTapFindPW }
    
    let obDidTapClose = backButton.rx.tap
      .map { _ in ViewModel.Command.didTapBackButton }
    
    Observable<ViewModel.Command>.merge([
        obViewDidLoad,
        obDidTapLogin,
        obDidTapSignup,
        obValidateField,
        obDidTapFindPW,
        obDidTapClose
      ])
      .bind(to: viewModel.command)
      .disposed(by: self.disposeBag)
  }

  
  
  //INPUT
  func state(viewModel: ViewModel) {
    
    viewModel.state
      .drive(onNext: { [weak self] state in
        guard let self = self else { return }
        
        switch state {
          
        case .viewDidLoadState:
          self.setupUI()
          
        case .didTapLoginState(let loginError):
          if loginError != nil {
            self.view.makeToast(loginError?.description, duration: 1.5, position: .center)
          } else {
            self.dismissKeyboard()
            self.push(to: Navigator.createSpcae.viewController)
          }
          
        case .didTapSignupState:
          self.dismissKeyboard()
          self.present(to: Navigator.signup.viewController)
          
        case .showIndicatorState(let isStarting):
          isStarting ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    
        case .validateFieldState(let isEnabled):
          self.loginButton.isActivate(by: isEnabled)
          
        case .didTapFindPWState:
          self.push(to: Navigator.findPassword.viewController)
          
        case .didTapBackButtonState:
          self.pop()
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension SignInViewController {

  private func setupUI() {
    
    view.backgroundColor = App.color.background
    
    // 타이틀
    titleLabel.font = App.font.bold(size: 20)
    
    // 텍스트필드 Container
    fieldContainer.layer.cornerRadius = Constant.cornerRadius
    fieldContainer.layer.borderColor = App.color.lightAlphaGray.cgColor
    fieldContainer.layer.borderWidth = 1
    separatorView.backgroundColor = App.color.lightAlphaGray
    
    // 비번번호 찾기 버튼
    let findPasswordAttributedText = NSMutableAttributedString(string: "비밀번호를 분실하셨나요?",
                                         attributes: [.foregroundColor : App.color.lightGray,
                                                      .font : App.font.medium(size: 12),
                                                      .underlineStyle: NSUnderlineStyle.single.rawValue])
    findPasswordButton.setAttributedTitle(findPasswordAttributedText, for: .normal)
    
    // 로그인 버튼
    loginButton.backgroundColor = App.color.main
    loginButton.layer.cornerRadius = Constant.cornerRadius
    loginButton.titleLabel?.font = App.font.bold(size: 18)
    loginButton.isEnabled = false
    
    // 회원가입 버튼
    let signupAttributedText = NSMutableAttributedString(string: "계정이 없으신가요? ",
                              attributes: [.foregroundColor : App.color.lightGray,
                                           .font : App.font.regular(size: 14)])
    signupAttributedText.append(NSMutableAttributedString(string: "회원 가입",
                                                          attributes: [.foregroundColor : UIColor.black,
                                                                       .font : App.font.bold(size: 14)]))
    signupButton.setAttributedTitle(signupAttributedText, for: .normal)
    signupHeightConstraint.constant = Constant.buttonHeight + Constant.safeAreaBottom
    
  }
  
}

