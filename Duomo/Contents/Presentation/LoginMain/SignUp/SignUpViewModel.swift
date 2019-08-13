//
//  SignUpViewModel.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewModel: BindViewModelType {
  
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewDidLoad
    case didInputInfo(_ name: String, _ email: String, _ password: String, _ confirmPassword: String)
    case didTapSignUp(_ name: String, _ email: String, _ password: String)
    case didTapClose
  }
  
  enum Action {
    case viewDidLoadAction
    case didInputInfoAction(_ name: String, _ email: String, _ password: String, _ confirmPassword: String)
    case didTapSignUpAction(_ name: String, _ email: String, _ password: String)
    case didTapCloseAction
  }
  
  enum State {
    case viewDidLoadState
    case didInputInfoState
    case didTapSignUpState(SignUpErrors?)
    case showIndicatorState(_ isStarting: Bool)
    case didTapCloseState
    case validatedFieldState(_ isValidating: Bool)
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  //MARK: - Properties
  var signupErrors: SignUpErrors? = nil
  let signupUseCase: SignUpUseCase
  
  
  
  //MARK: - Initialize
  init(signupUseCase: SignUpUseCase) {
    self.signupUseCase = signupUseCase
    self.bind()
  }
  
  
  //MARK: - Unidirection Action
  
  func toAction(from command: Command) -> Observable<Action> {
    switch command {
    case .viewDidLoad:
      return Observable<Action>.just(.viewDidLoadAction)
    case .didInputInfo(let name, let email, let password, let confirmPassword):
      return Observable<Action>.just(.didInputInfoAction(name, email, password, confirmPassword))
    case .didTapSignUp(let name, let email, let password):
      return Observable<Action>.just(.didTapSignUpAction(name, email, password))
    case .didTapClose:
      return Observable<Action>.just(.didTapCloseAction)
    }
  }

  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
      
    case .didInputInfoAction(let name, let email, let password, let confirmPassword):
      signupErrors = validateInfo(name: name,
                   email: email,
                   password: password,
                   confirmPassword: confirmPassword)
      validatedField(signupErrors)
      return Observable<State>.just(.didInputInfoState)
      
    case .didTapSignUpAction(let name, let email, let password):
      
      if signupErrors != nil {
        return Observable<State>.just(.didTapSignUpState(signupErrors))
      } else {
        showIndicator(true)
        return signupUseCase.signup(name: name, email: email, password: password)
          .flatMap { signupErrors -> Observable<State> in
            self.showIndicator(false)
            self.saveUserSession(name, email, password)
            return Observable<State>.just(.didTapSignUpState(signupErrors))
          }
      }
      
    case .didTapCloseAction:
      return Observable<State>.just(.didTapCloseState)
      
    }
  }
}

//MARK: - Method Handler
extension SignUpViewModel {
  
  private func validateInfo(name: String,
                            email: String,
                            password: String,
                            confirmPassword: String) -> SignUpErrors? {
    
    if name == "" && email == "" && password == "" && confirmPassword == "" {
      return SignUpErrors.empty
    }
    
    // 이름
    if name == "" || name == " " {
      return SignUpErrors.name
    }
    
    // 이메일
    if !email.validateEmail() {
      return SignUpErrors.email
    }
    
    // 비밀번호
    if !password.validatePassword() {
      return SignUpErrors.password
    }
    if password != confirmPassword {
      return SignUpErrors.confirmPassword
    }
    
    return nil
  }

  private func showIndicator(_ isStarting: Bool) {
    self.stateSubject.onNext(.showIndicatorState(isStarting))
  }
  
  private func validatedField(_ signupErrors: SignUpErrors?) {
    if signupErrors == nil {
      self.stateSubject.onNext(.validatedFieldState(true))
    } else {
      self.stateSubject.onNext(.validatedFieldState(false))
    }
  }
  
  private func saveUserSession(_ name: String, _ email: String, _ password: String) {
    App.preference.setObject(object: name , key: Preference.Key.name, type: .userDefault)
    App.preference.setObject(object: email , key: Preference.Key.email, type: .keychain)
    App.preference.setObject(object: password , key: Preference.Key.password, type: .keychain)
  }
  
}
