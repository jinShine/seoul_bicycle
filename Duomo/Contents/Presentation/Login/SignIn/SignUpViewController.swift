//
//  SignUpViewController.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let cornerRadius: CGFloat = 5
  }
  
  
  //MARK: - UI Properties
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var confirmPasswordField: UITextField!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var termButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var fieldContainer: UIView!
  
  
  
  //MARK: - Properties
  typealias ViewModel = SignUpViewModel
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
  
}

//MARK: - Bind
extension SignUpViewController {
  
  //OUTPUT
  func command(viewModel: ViewModel) {
    
    let obViewDidLoad = rx.viewDidLoad
      .map { ViewModel.Command.viewDidLoad }
    
    
    let obNameField = nameField.rx.text.orEmpty
    let obEmailField = emailField.rx.text.orEmpty
    let obPasswordField = passwordField.rx.text.orEmpty
    let obConfirmPasswordField = confirmPasswordField.rx.text.orEmpty

    let obCombineField = Observable.combineLatest([
        obNameField,
        obEmailField,
        obPasswordField,
        obConfirmPasswordField
      ])
      .map { combine in
        ViewModel.Command.didInputInfo(combine[0], combine[1], combine[2], combine[3])
      }
    
    let obDidTapSignUp = signupButton.rx.tap
      .map { _ in ViewModel.Command.didTapSignUp(self.nameField.text ?? "",
                                                 self.emailField.text ?? "",
                                                 self.passwordField.text ?? "") }
    
    let obDidTapClose = closeButton.rx.tap
      .map { _ in ViewModel.Command.didTapClose }
    
    Observable<ViewModel.Command>.merge([
        obViewDidLoad,
        obCombineField,
        obDidTapSignUp,
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
        case .didInputInfoState:
          return
        case .didTapSignUpState(let error):
          if error != nil {
            self.view.makeToast(error?.description, duration: 1.5, position: .center)
          } else {
            self.dismiss()
          }

        case .showIndicatorState(let isStarting):
          isStarting ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
          
        case .validatedFieldState(let isValidating):
          self.signupButton.isActivate(by: isValidating)
          
        case .didTapCloseState:
          self.dismiss()
          
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension SignUpViewController {
  
  private func setupUI() {
    
    containerView.backgroundColor = App.color.background
    
    // 타이틀
    titleLabel.font = App.font.bold(size: 20)
    
    // 텍스트필드 Container
    fieldContainer.layer.cornerRadius = Constant.cornerRadius
    fieldContainer.layer.borderColor = App.color.lightAlphaGray.cgColor
    fieldContainer.layer.borderWidth = 1

    nameField.placeholder = "이름"
    
    emailField.placeholder = "이메일 주소"
    emailField.keyboardType = .emailAddress
    
    passwordField.placeholder = "8자리 이상 영문자, 숫자 특수문자 포함"
    passwordField.isSecureTextEntry = true
    
    confirmPasswordField.placeholder = "비밀번호 확인"
    confirmPasswordField.isSecureTextEntry = true
    
    // 이용약관 버튼
    let termAttributedText = NSMutableAttributedString(string: "가입을 신청함으로써, ", attributes: [.foregroundColor : App.color.lightGray,
                                                                    .font : App.font.regular(size: 12)])
    termAttributedText.append(NSMutableAttributedString(string: "이용약관",
                                                        attributes: [.foregroundColor : UIColor.black,
                                                                     .font : App.font.bold(size: 12),
                                                                     .underlineStyle: NSUnderlineStyle.single.rawValue]))
    termAttributedText.append(NSMutableAttributedString(string: "에 동의 합니다.",
                                                        attributes: [.foregroundColor : App.color.lightGray,
                                                                     .font : App.font.bold(size: 12)]))
    termButton.setAttributedTitle(termAttributedText, for: .normal)
    
    // 회원가입 버튼
    signupButton.backgroundColor = App.color.main
    signupButton.layer.cornerRadius = Constant.cornerRadius
    signupButton.titleLabel?.font = App.font.bold(size: 18)
    signupButton.isEnabled = false
  }
  
}
