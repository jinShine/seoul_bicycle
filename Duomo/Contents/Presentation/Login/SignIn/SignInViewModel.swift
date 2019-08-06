//
//  SignInViewModel.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

final class SignInViewModel: BindViewModelType {
  
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewDidLoad
    case didInputInfo(_ name: String, _ email: String, _ password: String, _ confirmPassword: String)
  }
  
  enum Action {
    case viewDidLoadAction
    case didInputInfoAction(_ name: String, _ email: String, _ password: String, _ confirmPassword: String)
  }
  
  enum State {
    case viewDidLoadState
    case didInputInfoState((SignInErrors?, Bool))
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  var isSignInValidate = false
  
  
  //MARK: - Properties
  
  
  
  //MARK: - Initialize
  init() {
    
    self.bind()
  }
  
  
  //MARK: - Unidirection Action
  
  func toAction(from command: Command) -> Observable<Action> {
    switch command {
    case .viewDidLoad:
      return Observable<Action>.just(.viewDidLoadAction)
    case .didInputInfo(let name, let email, let password, let confirmPassword):
      return Observable<Action>.just(.didInputInfoAction(name, email, password, confirmPassword))
    }
  }

  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
    case .didInputInfoAction(let name, let email, let password, let confirmPassword):
      
      let result = validateInfo(name: name,
                   email: email,
                   password: password,
                   confirmPassword: confirmPassword)
      
      return Observable<State>.just(.didInputInfoState(result))
    }
  }
  
}

//MARK: - Method Handler
extension SignInViewModel {
  
  private func validateInfo(name: String, email: String, password: String, confirmPassword: String) -> (SignInErrors?, Bool) {
    
    isSignInValidate = true
    
    // 이름
    if name == "" || name == " " {
      isSignInValidate = false
      return (SignInErrors.name, false)
    }
    
    // 이메일
    if !email.validateEmail() {
      isSignInValidate = false
      return (SignInErrors.email, false)
    }
    
    // 비밀번호
    if !password.validatePassword() {
      isSignInValidate = false
      return (SignInErrors.password, false)
    }
    if password != confirmPassword {
      isSignInValidate = false
      return (SignInErrors.confirmPassword, false)
    }
    
    if name == "" && email == "" && password == "" && confirmPassword == "" {
      isSignInValidate = false
      return (SignInErrors.empty, false)
    }
    
    
    return (nil, true)
  }
  
}
