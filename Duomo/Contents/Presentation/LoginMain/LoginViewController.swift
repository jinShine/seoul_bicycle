//
//  LoginViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/10.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa


class LoginViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let cornerRadius: CGFloat = 5
  }
  
  
  //MARK: - UI Properties
  
  @IBOutlet weak var emailLoginButton: UIButton!
  @IBOutlet weak var kakaoLoginButton: KOLoginButton!
  
  
  
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismissKeyboard()
  }
  
}

//MARK: - Bind
extension LoginViewController {
  
  //OUTPUT
  func command(viewModel: ViewModel) {
    
    let obViewDidLoad = rx.viewDidLoad
      .map { ViewModel.Command.viewDidLoad }
    
    let obDidTapEmailLogin = emailLoginButton.rx.tap
      .map { _ in ViewModel.Command.didTapEmailLogin }
    
    let obDidTapKakaoLogin = kakaoLoginButton.rx.tap
      .map { ViewModel.Command.didTapKakao }
    
    Observable<ViewModel.Command>.merge([
        obViewDidLoad,
        obDidTapEmailLogin,
        obDidTapKakaoLogin
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
        case .viewDidLoadState:
          self.setupUI()
        case .didTapEmailLoginState:
          self.push(to: Navigator.signin.viewController)
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
  
  private func setupUI() {
    
    // 이메일 로그인 버튼
    emailLoginButton.backgroundColor = App.color.main
    emailLoginButton.layer.cornerRadius = Constant.cornerRadius
    emailLoginButton.titleLabel?.font = App.font.bold(size: 16)
    
    // 카카오 로그인 버튼
    kakaoLoginButton.layer.cornerRadius = Constant.cornerRadius
    kakaoLoginButton.titleLabel?.font = App.font.bold(size: 16)
    
  }
  
}

