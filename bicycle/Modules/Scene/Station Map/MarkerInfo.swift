//
//  MarkerInfo.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/18.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class MarkerInfo: UIView {

  @IBOutlet weak var contentView: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.contentView.layer.cornerRadius = 5
    self.contentView.layer.masksToBounds = true
  }
}
