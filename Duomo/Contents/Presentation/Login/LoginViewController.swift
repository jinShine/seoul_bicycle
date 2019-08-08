//
//  LoginViewController.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa


class LoginViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    
  }
  
  
  //MARK: - UI Properties
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var kakaoButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var findPasswordButton: UIButton!
  
  
  
  //MARK: - Properties
  typealias ViewModel = LoginViewModel
  var disposeBag = DisposeBag()
  
  
  
  init(viewModel: ViewModel) {
    defer {
      self.viewModel = viewModel
    }
    super.init()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }

}

//MARK: - Bind
extension LoginViewController {
  
  //OUTPUT
  func command(viewModel: ViewModel) {
    let obEmailField = emailField.rx.text.orEmpty
    let obPasswordField = passwordField.rx.text.orEmpty
    let obContents = Observable.combineLatest([obEmailField, obPasswordField])

    let obLogin = loginButton.rx.tap
      .withLatestFrom(obContents)
      .map { ViewModel.Command.didTapLogin(email: $0[0], password: $0[1]) }
    
    let obKakaoLogin = kakaoButton.rx.tap
      .map { ViewModel.Command.didTapKakao }
    
    let obSignup = signupButton.rx.tap
      .throttle(2.0, scheduler: MainScheduler.instance)
      .map { ViewModel.Command.didTapSignup }

    
    Observable<ViewModel.Command>.merge([
        obLogin,
        obKakaoLogin,
        obSignup
      ])
      .bind(to: viewModel.command)
      .disposed(by: self.disposeBag)
  }
  
  
  //INPUT
  func state(viewModel: ViewModel) {
    
    viewModel.state
      .drive(onNext: { [weak self] state in
        guard let self = self else { return }
        
        switch state {
        case .didTapLoginState(let loginError):
          if loginError != nil {
            self.view.makeToast(loginError?.description, duration: 1.5, position: .center)
          } else {
            //이동
          }
        case .didTapSignupState:
          self.navigationController?.pushViewController(Navigator.signup.viewController, animated: true)
        case .showIndicatorState(let isStarting):
          isStarting ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        case .didTapKakaoState(let error):
          if error != nil {
            if let error = error as NSError? {
              self.view.makeToast(error.description, duration: 1.5, position: .center)
            }
          } else {
            // 이동
          }
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension LoginViewController {

}

