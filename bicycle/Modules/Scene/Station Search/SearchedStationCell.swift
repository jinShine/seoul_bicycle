//
//  SearchedStationCell.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/26.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class SearchedStationCell: BaseTableViewCell {
  
  enum Constant {
    case indicator
    
    var image: UIImage? {
      switch self {
      case .indicator: return UIImage(named: "Icon-Indicator-Right")
      default: return nil
      }
    }
  }
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 15)
    label.textColor = AppTheme.color.blueMagenta
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  let distanceLabel: UILabel = {
    let label = UILabel()
    label.font = AppTheme.font.custom(size: 12)
    label.textColor = AppTheme.color.main
    return label
  }()
  
  let indicatorImage: UIImageView = {
    let imageView = UIImageView(image: Constant.indicator.image)
    imageView.tintColor = AppTheme.color.lightGray
    return imageView
  }()
  
  override func setupUI() {
    super.setupUI()
    
    [nameLabel, distanceLabel, indicatorImage].forEach { addSubview($0) }
    
    nameLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.lessThanOrEqualTo(distanceLabel.snp.leading).offset(-14)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(indicatorImage.snp.leading).offset(-4)
      $0.width.equalTo(40)
    }
    
    indicatorImage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-12)
      $0.size.equalTo(18)
    }
  }
  
  func configure(with station: Station) {
    nameLabel.text = station.stationName
    distanceLabel.text = station.distance
  }
}
