//
//  LoginViewController.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
  @IBAction func signInButtonDidTap(_ sender: UIButton) {
    let vc = UIStoryboard.create(SignUpViewController.self, name: "Login", bundle: nil, identifier: "SignUpViewController")
    vc.viewModel = SignUpViewModel()
    navigationController?.pushViewController(vc, animated: true)
    
  }
}
