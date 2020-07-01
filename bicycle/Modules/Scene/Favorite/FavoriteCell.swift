//
//  FavoriteCell.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/29.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteCell: BaseTableViewCell {
  
  enum Constant {
    case like, likeFill, distance, parkingBicycle
    
    var title: String {
      switch self {
      case .distance: return "거리"
      case .parkingBicycle: return "대여 가능 수"
      default: return ""
      }
    }
    
    var image: UIImage? {
      switch self {
      case .like: return UIImage(named: "Icon-Heart")
      case .likeFill: return UIImage(named: "Icon-Heart-Fill")
      default: return nil
      }
    }
  }
  
  lazy var bgView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = AppTheme.color.white
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = false
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 15)
    label.textColor = AppTheme.color.blueMagenta
    
    return label
  }()
  
  let distanceTitleLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 11)
    label.text = Constant.distance.title
    label.textAlignment = .center
    label.textColor = AppTheme.color.gray
    return label
  }()
  
  let distanceLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 14)
    label.textAlignment = .center
    label.textColor = AppTheme.color.main
    return label
  }()
  
  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = AppTheme.color.separator
    return view
  }()
  
  let parkingBicycleTitleLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 11)
    label.text = Constant.parkingBicycle.title
    label.textAlignment = .center
    label.textColor = AppTheme.color.gray
    return label
  }()
  
  let parkingBicycleLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 14)
    label.textColor = AppTheme.color.main
    label.textAlignment = .center
    return label
  }()
  
  let likeButton: UIButton = {
    let button = UIButton()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(Constant.likeFill.image, for: .normal)
    return button
  }()

  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override func setupUI() {
    super.setupUI()
    
    backgroundColor = .clear
    layer.applyShadow(x: 0, y: 1, blur: 2)
    
    [bgView].forEach { addSubview($0) }
    [nameLabel, distanceTitleLabel, distanceLabel,
      lineView, parkingBicycleTitleLabel, parkingBicycleLabel,
      likeButton].forEach { bgView.addSubview($0) }
    
    bgView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview()
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalTo(likeButton.snp.leading).offset(-16)
    }
    
    likeButton.snp.makeConstraints {
      $0.leading.lessThanOrEqualTo(nameLabel.snp.trailing).offset(16)
      $0.trailing.equalTo(-24)
      $0.centerY.equalTo(nameLabel)
            $0.size.equalTo(50)
//      $0.width.equalTo(20)
//      $0.height.equalTo(18)
    }
    
    distanceTitleLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(24)
      $0.leading.equalTo(nameLabel)
      $0.trailing.equalTo(lineView.snp.leading)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(distanceTitleLabel.snp.bottom).offset(8)
      $0.centerX.equalTo(distanceTitleLabel)
      $0.bottom.equalTo(lineView)
    }
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(distanceTitleLabel)
      $0.centerX.equalTo(nameLabel)
      $0.width.equalTo(1)
      $0.bottom.equalToSuperview().offset(-16)
    }
    
    parkingBicycleTitleLabel.snp.makeConstraints {
      $0.top.equalTo(distanceTitleLabel)
      $0.leading.equalTo(lineView)
      $0.trailing.equalTo(nameLabel)
    }
    
    parkingBicycleLabel.snp.makeConstraints {
      $0.top.equalTo(distanceTitleLabel.snp.bottom).offset(8)
      $0.centerX.equalTo(parkingBicycleTitleLabel)
      $0.bottom.equalTo(lineView)
    }
  }
  
  func configure(with station: Station) {
    nameLabel.text = station.stationName
    distanceLabel.text = station.distance?.toMeter
    parkingBicycleLabel.text = station.parkingBikeTotCnt
  }
}

