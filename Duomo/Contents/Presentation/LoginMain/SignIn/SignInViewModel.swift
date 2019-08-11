//
//  SignInViewModel.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

final class SignInViewModel: BindViewModelType {
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewDidLoad
    case didTapLogin(email: String, password: String)
    case didTapSignup
    case validateField(email: String, password: String)
    case didTapFindPW
    case didTapBackButton
  }
  
  enum Action {
    case viewDidLoadAction
    case didTapLoginAction(email: String, password: String)
    case didTapSignupAction
    case validateFieldAction(email: String, password: String)
    case didTapFindPWAction
    case didTapBackButtonAction
  }
  
  enum State {
    case viewDidLoadState
    case didTapLoginState(SignInError?)
    case didTapSignupState
    case showIndicatorState(_ isStarting: Bool)
    case validateFieldState(Bool)
    case didTapFindPWState
    case didTapBackButtonState
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  
  
  //MARK: - Properties
  var signinUseCase: SignInUseCase
  
  
  
  
  //MARK: - Initialize
  init(signinUseCase: SignInUseCase) {
    self.signinUseCase = signinUseCase
    self.bind()
  }
  
  
  //MARK: - Unidirection Action
  
  func toAction(from command: Command) -> Observable<Action> {
    switch command {
    case .viewDidLoad:
      return Observable<Action>.just(.viewDidLoadAction)
    case .didTapLogin(let email, let password):
      return Observable<Action>.just(.didTapLoginAction(email: email, password: password))
    case .didTapSignup:
      return Observable<Action>.just(.didTapSignupAction)
    case .validateField(let email, let password):
      return Observable<Action>.just(.validateFieldAction(email: email, password: password))
    case .didTapFindPW:
      return Observable<Action>.just(.didTapFindPWAction)
    case .didTapBackButton:
      return Observable<Action>.just(.didTapBackButtonAction)
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
    case .didTapLoginAction(let email, let password):
      showIndicator(true)
      return signinUseCase.login(email: email, password: password)
        .flatMap { loginError -> Observable<State> in
          self.showIndicator(false)
          return Observable<State>.just(.didTapLoginState(loginError))
        }
    case .didTapSignupAction:
      return Observable<State>.just(.didTapSignupState)
    
    case .validateFieldAction(let email, let password):
      if email.validateEmail() && password.validatePassword() {
        return Observable<State>.just(.validateFieldState(true))
      }
      return Observable<State>.just(.validateFieldState(false))
      
    case .didTapFindPWAction:
      return Observable<State>.just(.didTapFindPWState)
    case .didTapBackButtonAction:
      return Observable<State>.just(.didTapBackButtonState)
    }
  }
  
}

//MARK: - Method Handler
extension SignInViewModel {
  
  private func showIndicator(_ isStarting: Bool) {
    self.stateSubject.onNext(.showIndicatorState(isStarting))
  }

}

