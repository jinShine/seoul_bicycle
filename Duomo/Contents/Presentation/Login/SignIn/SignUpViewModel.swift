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
  }
  
  enum Action {
    case viewDidLoadAction
    case didInputInfoAction(_ name: String, _ email: String, _ password: String, _ confirmPassword: String)
    case didTapSignUpAction(_ name: String, _ email: String, _ password: String)
  }
  
  enum State {
    case viewDidLoadState
    case didInputInfoState
    case didTapSignUpState(SignUpErrors?)
    case showIndicatorState(_ isStarting: Bool)
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  //MARK: - Properties
  var signupErrors: SignUpErrors? = nil
  
  
  
  
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
    case .didTapSignUp(let name, let email, let password):
      return Observable<Action>.just(.didTapSignUpAction(name, email, password))
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
      
      return Observable<State>.just(.didInputInfoState)
      
    case .didTapSignUpAction(let name, let email, let password):
      
      if signupErrors != nil {
        return Observable<State>.just(.didTapSignUpState(signupErrors))
      } else {
        return signup(name, email, password)
      }
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
  
  private func signup(_ name: String,
                      _ email: String,
                      _ password: String) -> Observable<State> {
    return Observable<State>.create { [weak self]  (observer) -> Disposable in
      guard let self = self else { return Disposables.create() }
      
      self.showIndicator(true)
      Auth.auth().createUser(withEmail: email,
                             password: password) { (result, error) in
        if let error = error {
          ELog(error: error)
          observer.onNext(.didTapSignUpState(SignUpErrors.alreadyRegister))
          self.showIndicator(false)
          return
        }
        DLog("SignUp Success!")
        
        guard let uid = result?.user.uid else { return }
        let data = [uid: ["name": name]]
        
        App.firestore.db
          .collection("users")
          .addDocument(data: data, completion: { error in
            
            if let error = error {
              ELog(error: error)
              // DB 저장중 에러나면 계정 생성 삭제
              Auth.auth().currentUser?.delete(completion: nil)
              self.showIndicator(false)
              return
            }

            observer.onNext(.didTapSignUpState(self.signupErrors))
            observer.onCompleted()
            DLog("Data Save Success!")
          })
      }
      
      return Disposables.create {
        self.showIndicator(false)
      }
    }
  }
  
  private func showIndicator(_ isStarting: Bool) {
    self.stateSubject.onNext(.showIndicatorState(isStarting))
  }
}
