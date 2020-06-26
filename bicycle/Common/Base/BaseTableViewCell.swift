//
//  BaseTableViewCell.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/26.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  func setupUI() {
    
  }
  
}
