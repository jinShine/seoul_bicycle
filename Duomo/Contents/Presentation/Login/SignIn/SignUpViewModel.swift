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
    case didTapSignUpState
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  //MARK: - Properties
  var isSignUpValidate = false
  var validateResult: (SignUpErrors?, Bool)?
  
  
  
  
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
      
      validateResult = validateInfo(name: name,
                   email: email,
                   password: password,
                   confirmPassword: confirmPassword)
      
      return Observable<State>.just(.didInputInfoState)
      
    case .didTapSignUpAction(let name, let email, let password):
      return Observable<State>.create { (observer) -> Disposable in
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
          if let error = error {
            ELog(error: error)
            return
          }
          DLog("SignUp Success!")
          
          guard let uid = result?.user.uid else { return }
          let data = [uid: ["name": name]]
          App.firestore.create(collection: "users", data: data, completion: { error in
            if let error = error {
              ELog(error: error)
              
              Auth.auth().currentUser?.delete(completion: { error in
                if let error = error {
                  ELog(error: error)
                }
              })
              
              
              return
            }
            
            observer.onCompleted()
            DLog("설마")
          })
        }
        
        return Disposables.create()
      }
    }
  }
}

//MARK: - Method Handler
extension SignUpViewModel {
  
  private func validateInfo(name: String,
                            email: String,
                            password: String,
                            confirmPassword: String) -> (SignUpErrors?, Bool) {
    
    isSignUpValidate = true
    
    // 이름
    if name == "" || name == " " {
      isSignUpValidate = false
      return (SignUpErrors.name, false)
    }
    
    // 이메일
    if !email.validateEmail() {
      isSignUpValidate = false
      return (SignUpErrors.email, false)
    }
    
    // 비밀번호
    if !password.validatePassword() {
      isSignUpValidate = false
      return (SignUpErrors.password, false)
    }
    if password != confirmPassword {
      isSignUpValidate = false
      return (SignUpErrors.confirmPassword, false)
    }
    
    if name == "" && email == "" && password == "" && confirmPassword == "" {
      isSignUpValidate = false
      return (SignUpErrors.empty, false)
    }
    
    
    return (nil, true)
  }
  
}
