//
//  EmptyView.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/29.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class EmptyView: UIView {
  
  enum Constant {
    case stateImage, stateTitle, stateSub, stateButton
    
    var title: String {
      switch self {
      case .stateTitle: return "등록된 즐겨찾기가 없습니다."
      case .stateSub: return "지도에서 즐겨찾는 곳을 등록해보세요"
      case .stateButton: return "지도로 이동"
      default: return ""
      }
    }
    var image: UIImage? {
      switch self {
      case .stateImage: return UIImage(named: "EmptyStateImage")
      default: return nil
      }
    }
  }
  
  let emptyImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Constant.stateImage.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 18)
    label.text = Constant.stateTitle.title
    label.textColor = AppTheme.color.blueMagenta
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let subLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 14)
    label.text = Constant.stateSub.title
    label.textColor = AppTheme.color.gray
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let okButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = AppTheme.color.main
    button.setTitle(Constant.stateButton.title, for: .normal)
    button.setTitleColor(AppTheme.color.white, for: .normal)
    button.titleLabel?.font = AppTheme.font.custom(size: 18)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    [emptyImageView, titleLabel, subLabel, okButton].forEach {
      addSubview($0)
    }
    
    emptyImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.equalTo(250)
      $0.height.equalTo(200)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
      $0.leading.equalTo(emptyImageView)
      $0.trailing.equalTo(emptyImageView)
    }
    
    subLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalTo(titleLabel)
    }
    
    okButton.layer.cornerRadius = 27.5
    okButton.layer.masksToBounds = false
    okButton.snp.makeConstraints {
      $0.top.equalTo(subLabel.snp.bottom).offset(30)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalTo(titleLabel)
      $0.height.equalTo(55)
    }
  }
}
