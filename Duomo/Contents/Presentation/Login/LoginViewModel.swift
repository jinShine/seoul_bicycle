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
    case viewDidLoad
    case didTapLogin(email: String, password: String)
    case didTapSignup
    case didTapKakao
    case validateField(email: String, password: String)
  }
  
  enum Action {
    case viewDidLoadAction
    case didTapLoginAction(email: String, password: String)
    case didTapSignupAction
    case didTapKakaoAction
    case validateFieldAction(email: String, password: String)
  }
  
  enum State {
    case viewDidLoadState
    case didTapLoginState(LoginError?)
    case didTapSignupState
    case showIndicatorState(_ isStarting: Bool)
    case didTapKakaoState(Error?)
    case validateFieldState(Bool)
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
    case .viewDidLoad:
      return Observable<Action>.just(.viewDidLoadAction)
    case .didTapLogin(let email, let password):
      return Observable<Action>.just(.didTapLoginAction(email: email, password: password))
    case .didTapSignup:
      return Observable<Action>.just(.didTapSignupAction)
    case .didTapKakao:
      return Observable<Action>.just(.didTapKakaoAction)
    case .validateField(let email, let password):
      return Observable<Action>.just(.validateFieldAction(email: email, password: password))
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
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
      let token = loginUseCase.kakaoToken()
      return loginUseCase.kakaoLogin()
        .flatMap { (error, result) -> Observable<State> in
          let data = [token ?? "" : [
              "name" : result?.nickname,
              "profileImage" : result?.properties?["profile_image"]
            ]]
          App.firestore.create(collection: "users", data: data, completion: nil)
          
          return Observable<State>.just(.didTapKakaoState(error))
        }
    case .validateFieldAction(let email, let password):
      if email.validateEmail() && password.validatePassword() {
        return Observable<State>.just(.validateFieldState(true))
      }
      return Observable<State>.just(.validateFieldState(false))
    }
  }
  
}

//MARK: - Method Handler
extension LoginViewModel {
  
  private func showIndicator(_ isStarting: Bool) {
    self.stateSubject.onNext(.showIndicatorState(isStarting))
  }

}

