//
//  FindPasswordViewModel.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/09.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

final class FindPasswordViewModel: BindViewModelType {
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewDidLoad
    case didTapSendEmail(email: String)
    case validateEmail(email: String)
    case didTapBackButton
  }
  
  enum Action {
    case viewDidLoadAction
    case didTapSendEmailAction(email: String)
    case validateEmailAction(email: String)
    case didTapBackButtonAction
  }
  
  enum State {
    case viewDidLoadState
    case didTapSendEmailState(FindPasswordError?)
    case validateEmailState(_ isValidating: Bool)
    case showIndicatorState(_ isStarting: Bool)
    case didTapBackButtonState
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  
  
  //MARK: - Properties
  var findPasswordUseCase: FindPasswordUseCase
  
  
  //MARK: - Initialize
  init(findPasswordUseCase: FindPasswordUseCase) {
    self.findPasswordUseCase = findPasswordUseCase
    self.bind()
  }
  
  
  //MARK: - Unidirection Action
  
  func toAction(from command: Command) -> Observable<Action> {
    switch command {
    case .viewDidLoad:
      return Observable<Action>.just(.viewDidLoadAction)
    case .didTapSendEmail(let email):
      return Observable<Action>.just(.didTapSendEmailAction(email: email))
    case .validateEmail(let email):
      return Observable<Action>.just(.validateEmailAction(email: email))
    case .didTapBackButton:
      return Observable<Action>.just(.didTapBackButtonAction)
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
    case .didTapSendEmailAction(let email):
      showIndicator(true)
      return findPasswordUseCase.sendPasswordReset(forEmail: email)
        .asObservable()
        .flatMap { error -> Observable<State> in
          self.showIndicator(false)
          return Observable<State>.just(.didTapSendEmailState(error))
        }
        .catchError { error -> Observable<State> in
          self.showIndicator(false)
          return Observable<State>.just(.didTapSendEmailState(error as? FindPasswordError))
      }
    case .validateEmailAction(let email):
      if email.validateEmail() {
        return Observable<State>.just(.validateEmailState(true))
      } else {
        return Observable<State>.just(.validateEmailState(false))
      }
    case .didTapBackButtonAction:
      return Observable<State>.just(.didTapBackButtonState)
    }
  }
  
}

//MARK: - Method Handler
extension FindPasswordViewModel {
  
  private func showIndicator(_ isStarting: Bool) {
    self.stateSubject.onNext(.showIndicatorState(isStarting))
  }
  
}


