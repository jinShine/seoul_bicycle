//
//  SignInViewModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/01.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: BaseViewModel, ViewModelType {
  
  struct Input {
    let userInfo: Observable<(String, String)>
  }
  
  struct Output {
    let loginSuccess: Observable<Data?>
  }

  let seoulBikeAPIInteractor: SeoulBikeAPIUseCase
  
  init(seoulBikeAPIInteractor: SeoulBikeAPIUseCase) {
    self.seoulBikeAPIInteractor = seoulBikeAPIInteractor
  }

  func transform(input: Input) -> Output {
    
    let loginSuccess = input.userInfo
      .flatMap { (id, pw) in
        self.seoulBikeAPIInteractor.login(id: id, pw: pw)
    }
    
      
    

    return Output(loginSuccess: loginSuccess)
  }
}

//MARK:- Action Methods
