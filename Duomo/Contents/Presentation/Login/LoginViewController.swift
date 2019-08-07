//
//  LoginViewController.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit
import KakaoOpenSDK

class LoginViewController: UIViewController {
  
  
  @IBOutlet weak var kakaoButton: KOLoginButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }

  
  @IBAction func signInButtonDidTap(_ sender: UIButton) {
    let vc = UIStoryboard.create(SignUpViewController.self, name: "Login", bundle: nil, identifier: "SignUpViewController")
    vc.viewModel = SignUpViewModel(signupUseCase: SignUpInteractor())
    navigationController?.pushViewController(vc, animated: true)
    
  }
}
