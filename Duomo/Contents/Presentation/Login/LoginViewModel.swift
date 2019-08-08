//
//  LoginViewModel.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

final class LoginViewModel: BindViewModelType {
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case didTapLogin(email: String, password: String)
    case didTapSignup
    case didTapKakao
  }
  
  enum Action {
    case didTapLoginAction(email: String, password: String)
    case didTapSignupAction
    case didTapKakaoAction
  }
  
  enum State {
    case didTapLoginState(LoginError?)
    case didTapSignupState
    case showIndicatorState(_ isStarting: Bool)
    case didTapKakaoState(Error?, KOUserMe?)
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  
  
  //MARK: - Properties
  var loginUseCase: LoginUseCase
  
  
  
  
  //MARK: - Initialize
  init(loginUseCase: LoginUseCase) {
    self.loginUseCase = loginUseCase
    self.bind()
  }
  
  
  //MARK: - Unidirection Action
  
  func toAction(from command: Command) -> Observable<Action> {
    switch command {
    case .didTapLogin(let email, let password):
      return Observable<Action>.just(.didTapLoginAction(email: email, password: password))
    case .didTapSignup:
      return Observable<Action>.just(.didTapSignupAction)
    case .didTapKakao:
      return Observable<Action>.just(.didTapKakaoAction)
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .didTapLoginAction(let email, let password):
      showIndicator(true)
      return loginUseCase.login(email: email, password: password)
        .flatMap { loginError -> Observable<State> in
          self.showIndicator(false)
          return Observable<State>.just(.didTapLoginState(loginError))
        }
    case .didTapSignupAction:
      return Observable<State>.just(.didTapSignupState)
    case .didTapKakaoAction:
      return loginUseCase.kakaoLogin()
        .flatMap { (error, result) -> Observable<State> in
          print(result)
          
          return Observable<State>.just(.didTapKakaoState(error, result))
        }.catchErrorJustReturn(.didTapKakaoState(nil, nil))
      
    }
  }
  
}

//MARK: - Method Handler
extension LoginViewModel {
  
  private func showIndicator(_ isStarting: Bool) {
    self.stateSubject.onNext(.showIndicatorState(isStarting))
  }
  
}

