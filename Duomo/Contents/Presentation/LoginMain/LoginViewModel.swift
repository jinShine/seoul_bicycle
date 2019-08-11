//
//  LoginViewModel.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/10.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

final class LoginViewModel: BindViewModelType {
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewDidLoad
    case didTapEmailLogin
    case didTapKakao
  }
  
  enum Action {
    case viewDidLoadAction
    case didTapEmailLoginAction
    case didTapKakaoAction
  }
  
  enum State {
    case viewDidLoadState
    case didTapEmailLoginState
    case didTapKakaoState(Error?)
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
    case .didTapEmailLogin:
      return Observable<Action>.just(.didTapEmailLoginAction)
    case .didTapKakao:
      return Observable<Action>.just(.didTapKakaoAction)
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
    case .didTapEmailLoginAction:
      return Observable<State>.just(.didTapEmailLoginState)
    case .didTapKakaoAction:
      let token = signinUseCase.kakaoToken()
      return signinUseCase.kakaoLogin()
        .flatMap { (error, result) -> Observable<State> in
          
          
          let data = [token ?? "" : [
            "name" : result?.nickname,
            "profileImage" : result?.properties?["profile_image"]
            ]]
          App.firestore.create(collection: "users", data: data, completion: nil)
          
          return Observable<State>.just(.didTapKakaoState(error))
      }
    }
  }
  
}

//MARK: - Method Handler
extension LoginViewModel {
  
//  private func showIndicator(_ isStarting: Bool) {
//    self.stateSubject.onNext(.showIndicatorState(isStarting))
//  }
  
}


