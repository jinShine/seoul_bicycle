//
//  CreateSpaceViewModel.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/11.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

final class CreateSpaceViewModel: BindViewModelType {
  
  //MARK: - Constant
  
  struct Constant {
    
  }
  
  
  //MARK: - Unidirection
  
  enum Command {
    case viewDidLoad
    case didInputInfo(_ spaceName: String, _ password: String)
    case didTapCreateButton(_ spaceName: String)
  }
  
  enum Action {
    case viewDidLoadAction
    case didInputInfo(_ spaceName: String, _ password: String)
    case didTapCreateButtonAction(_ spaceName: String)
  }
  
  enum State {
    case viewDidLoadState
    case didInputInfo(Bool)
    case didTapCreateButtonState
  }
  
  var command = PublishSubject<Command>()
  var state = Driver<State>.empty()
  var stateSubject = PublishSubject<State>()
  
  
  
  
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
    case .didInputInfo(let name, let password):
      return Observable<Action>.just(.didInputInfo(name, password))
    case .didTapCreateButton(let spaceName):
      return Observable<Action>.just(.didTapCreateButtonAction(spaceName))
    }
  }
  
  func toState(from action: Action) -> Observable<State> {
    switch action {
    case .viewDidLoadAction:
      return Observable<State>.just(.viewDidLoadState)
    case .didInputInfo(let name, let password):
      let validated = validateInfo(name: name, password: password)
      return Observable<State>.just(.didInputInfo(validated))
    case .didTapCreateButtonAction(let spaceName):
      let token = App.preference.objectForKey(key: Preference.Key.token, type: .keychain)
      
      App.firestore.db.collection("spaces").document(spaceName).setData(<#T##documentData: [String : Any]##[String : Any]#>)

      App.firestore.create(collection: "spaces", data: data, completion: nil)
      return Observable<State>.just(.didTapCreateButtonState)
    }
  }
  
}

//MARK: - Method Handler
extension CreateSpaceViewModel {
  
  //  private func showIndicator(_ isStarting: Bool) {
  //    self.stateSubject.onNext(.showIndicatorState(isStarting))
  //  }
  
  private func validateInfo(name: String,
                            password: String) -> Bool {
    guard name.count >= 1 && password.count >= 4 else {
      return false
    }
    
    return true
  }
  
}
