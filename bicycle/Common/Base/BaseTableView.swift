//
//  BaseTableView.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/25.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableView: UITableView {
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  func setupUI() {
    
    rowHeight = UITableView.automaticDimension
    estimatedRowHeight = 80
    sectionHeaderHeight = 30
    backgroundColor = .clear
    cellLayoutMarginsFollowReadableWidth = false
    keyboardDismissMode = .onDrag
    tableFooterView = UIView()
  }
}
