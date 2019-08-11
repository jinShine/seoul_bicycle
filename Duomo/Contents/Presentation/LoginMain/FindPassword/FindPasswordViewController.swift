//
//  FindPasswordViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/09.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa


class FindPasswordViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let cornerRadius: CGFloat = 5
  }
  
  
  //MARK: - UI Properties
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var fieldContainer: UIView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var subContentLabel: UILabel!
  @IBOutlet weak var sendEmailButton: UIButton!

  
  //MARK: - Properties
  typealias ViewModel = FindPasswordViewModel
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
extension FindPasswordViewController {
  
  //OUTPUT
  func command(viewModel: ViewModel) {
    
    let obViewDidLoad = rx.viewDidLoad
      .map { _ in ViewModel.Command.viewDidLoad }
    
    let obEmailFieldShare = emailField.rx.text.orEmpty.share()
    
    let obEmailField = obEmailFieldShare
      .map { ViewModel.Command.validateEmail(email: $0) }
    
    let obDidTapSendEmail = sendEmailButton.rx.tap
      .withLatestFrom(obEmailFieldShare)
      .map { ViewModel.Command.didTapSendEmail(email: $0) }

    let obDidTapBackButton = backButton.rx.tap
      .map { _ in ViewModel.Command.didTapBackButton }
    
    Observable<ViewModel.Command>.merge([
        obViewDidLoad,
        obDidTapSendEmail,
        obEmailField,
        obDidTapBackButton
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
        case .didTapSendEmailState(let error):
          if error != nil {
            self.view.makeToast(error?.description, duration: 1.5, position: .center)
          } else {
            self.dismissKeyboard()
            self.pop()
          }
        case .validateEmailState(let isEnabled):
          self.sendEmailButton.isActivate(by: isEnabled)
        case .showIndicatorState(let isStarting):
          isStarting ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        case .didTapBackButtonState:
          self.pop()
        }

      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension FindPasswordViewController {
  
  private func setupUI() {
    
    view.backgroundColor = App.color.background
    
    // 텍스트필드 Container
    fieldContainer.layer.cornerRadius = Constant.cornerRadius
    fieldContainer.layer.borderColor = App.color.lightAlphaGray.cgColor
    fieldContainer.layer.borderWidth = 1
    
    
    subContentLabel.text = "가입하셨던 이메일 주소를 입력해주세요."
    subContentLabel.textColor = App.color.lightGray
    subContentLabel.font = App.font.medium(size: 12)
    
    
    // 이메일 전송 버튼
    sendEmailButton.backgroundColor = App.color.main
    sendEmailButton.layer.cornerRadius = Constant.cornerRadius
    sendEmailButton.titleLabel?.font = App.font.bold(size: 18)
    sendEmailButton.isEnabled = false
    
  }
  
}


