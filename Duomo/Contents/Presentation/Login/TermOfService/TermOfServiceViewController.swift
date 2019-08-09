//
//  TermOfServiceViewController.swift
//  Duomo
//
//  Created by Seungjin on 09/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import UIKit

class TermOfServiceViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    textView.attributedText = NSAttributedString.readRTF(forResource: "TermOfServiceFile")
    
  }
  
  @IBAction func close(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
