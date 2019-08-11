//
//  CreateSpaceViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/11.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa


class CreateSpaceViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let cornerRadius: CGFloat = 5
  }
  
  
  //MARK: - UI Properties
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var fieldContainer: UIView!
  @IBOutlet weak var spaceNameField: UITextField!
  @IBOutlet weak var spacePwField: UITextField!
  @IBOutlet weak var subContentLabel: UILabel!
  @IBOutlet weak var createButton: UIButton!
  
  
  
  //MARK: - Properties
  typealias ViewModel = CreateSpaceViewModel
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
extension CreateSpaceViewController {
  
  //OUTPUT
  func command(viewModel: ViewModel) {
    
    let obViewDidLoad = rx.viewDidLoad
      .map { ViewModel.Command.viewDidLoad }
    
    let obSpaceNameField = spaceNameField.rx.text.orEmpty
    let obSpacePwField = spacePwField.rx.text.orEmpty
    let obCombineField = Observable.combineLatest([
        obSpaceNameField,
        obSpacePwField
      ])
      .map { combine in
        ViewModel.Command.didInputInfo(combine[0], combine[1])
      }
    
    let obDidTapCreateButton = createButton.rx.tap
      .withLatestFrom(obSpaceNameField)
      .map { ViewModel.Command.didTapCreateButton($0) }
    
    Observable<ViewModel.Command>.merge([
        obViewDidLoad,
        obCombineField,
        obDidTapCreateButton
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
        case .didInputInfo(let validated):
          self.createButton.isActivate(by: validated)
        case .didTapCreateButtonState:
          return
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension CreateSpaceViewController {
  
  private func setupUI() {
    
    view.backgroundColor = App.color.background
    
    // 타이틀
    titleLabel.font = App.font.bold(size: 20)
    
    spaceNameField.placeholder = "공간명"
    
    spacePwField.placeholder = "4자리 이상의 자유로운 비밀번호"
    spacePwField.isSecureTextEntry = true
    
    // 텍스트필드 Container
    fieldContainer.layer.cornerRadius = Constant.cornerRadius
    fieldContainer.layer.borderColor = App.color.lightAlphaGray.cgColor
    fieldContainer.layer.borderWidth = 1
    
    subContentLabel.text = "서로의 공간을 만들고,\n연인에게 공간명과 비밀번호를 공유해주세요.\n이 과정은 최초 한번만 진행됩니다."
    subContentLabel.textColor = App.color.lightGray
    subContentLabel.font = App.font.medium(size: 12)
    
    // 공간 만들기 버튼
    createButton.backgroundColor = App.color.main
    createButton.layer.cornerRadius = Constant.cornerRadius
    createButton.titleLabel?.font = App.font.bold(size: 18)
    createButton.isEnabled = false
    
  }
  
}
