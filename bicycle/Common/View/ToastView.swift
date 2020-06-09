//
//  ToastView.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/10.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import SwiftEntryKit

class ToastView: UIView {
  
  enum Status {
    case success, error, gold
    
    var image: UIImage? {
      switch self {
      case .success: return UIImage(named: "Icon-Toast-Success")
      case .error: return UIImage(named: "Icon-Toast-Error")
      case .gold: return UIImage(named: "Icon-Toast-Gold")
      }
    }
  }
  
  let statusImage = UIImageView()
  let statusMessage: UILabel = {
    let label = UILabel()
    label.textColor = AppTheme.color.gray
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    backgroundColor = .white
    layer.cornerRadius = 5
    layer.masksToBounds = true
    layer.applyShadow()
    
    [statusImage, statusMessage].forEach { self.addSubview($0) }
    
    statusImage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.size.equalTo(20)
    }
    
    statusMessage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(statusImage.snp.trailing).offset(24)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.lessThanOrEqualToSuperview().offset(-5)
    }
  }
  
  func show(image status: Status, message: String, position: EKAttributes = .topFloat) {
    toast(status: status, message: message)
    SwiftEntryKit.display(entry: self, using: position)
  }
  
  private func toast(status: Status, message: String, position: EKAttributes = .topFloat) {
    switch status {
    case .success:
      statusImage.image = Status.success.image
      statusMessage.text = message
      SwiftEntryKit.display(entry: self, using: position)
    case .error:
      statusImage.image = Status.error.image
      statusMessage.text = message
      SwiftEntryKit.display(entry: self, using: position)
    case .gold:
      statusImage.image = Status.gold.image
      statusMessage.text = message
      SwiftEntryKit.display(entry: self, using: position)
    }
  }
  
}
