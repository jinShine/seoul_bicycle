//
//  SignInViewController.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import Toast_Swift

class SignInViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    
  }
  
  
  //MARK: - UI Properties
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var confirmPasswordField: UITextField!
  @IBOutlet weak var signinButton: UIButton!
  
  
  //MARK: - Properties
  typealias ViewModel = SignInViewModel
  var disposeBag = DisposeBag()
  //  var dataSource: RxTableViewSectionedReloadDataSource<SectionOfUserModel>?
  
  
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
extension SignInViewController {
  
  //OUTPUT
  func command(viewModel: SignInViewModel) {
    
    let obViewDidLoad = rx.viewDidLoad
      .map { ViewModel.Command.viewDidLoad }
    
    
    let obNameField = nameField.rx.text.orEmpty
    let obEmailField = emailField.rx.text.orEmpty
    let obPasswordField = passwordField.rx.text.orEmpty
    let obConfirmPasswordField = confirmPasswordField.rx.text.orEmpty

    let obCombineField = Observable
      .combineLatest([
        obNameField,
        obEmailField,
        obPasswordField,
        obConfirmPasswordField
        ])
      .map { combine in
        ViewModel.Command.didInputInfo(combine[0], combine[1], combine[2], combine[3])
      }
    
    
    Observable<ViewModel.Command>.merge([
        obViewDidLoad,
        obCombineField
      ])
      .bind(to: viewModel.command)
      .disposed(by: self.disposeBag)
  }
  
  
  //INPUT
  func state(viewModel: SignInViewModel) {
    
    viewModel.state
      .drive(onNext: { [weak self] state in
        guard let self = self else { return }
        
        switch state {
        case .viewDidLoadState:
          self.setupUI()
        case .didInputInfoState((let error, let state)):
          guard let error = error else {
            print("가입 성공")
            return
          }
          
          switch error.self {
          case .name:
//            self.view.makeToast(error.)
          case .email:
            self.view.makeToast(error.localizedDescription)
          case .password:
            self.view.makeToast(error.localizedDescription)
          case .confirmPassword:
            self.view.makeToast(error.localizedDescription)
          case .empty:
            self.view.makeToast(error.localizedDescription)
          }
        }
        
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension SignInViewController {
  
  private func setupUI() {
    
    nameField.placeholder = "이름을 입력해주세요."
    
    emailField.placeholder = "email@duomoapp.com"
    emailField.keyboardType = .emailAddress
    
    passwordField.placeholder = "8자리 이상 영문자, 숫자 특수문자 포함"
    passwordField.isSecureTextEntry = true
    
    confirmPasswordField.placeholder = "비밀번호 확인"
    confirmPasswordField.isSecureTextEntry = true
    
  }
  
}
