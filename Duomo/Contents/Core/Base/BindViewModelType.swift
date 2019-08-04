//
//  BindViewModelType.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol BindViewModelType: class {
  associatedtype Command
  associatedtype Action
  associatedtype State
  
  var command: PublishSubject<Command> { get }
  var stateSubject: PublishSubject<State> { get }
  var state: Driver<State> { get set }
  
  func toAction(from command: Command) -> Observable<Action>
  func toState(from action: Action) -> Observable<State>
}

extension BindViewModelType {
  
  func bind() {
  
    state = Observable<State>.merge(self.stateSubject.asObserver(),
                                    self.command
                                      .flatMap { self.toAction(from: $0) }
                                      .flatMap { self.toState(from: $0) }
      ).asDriver { error in
        return Driver.empty()
    }
  }
  
}
