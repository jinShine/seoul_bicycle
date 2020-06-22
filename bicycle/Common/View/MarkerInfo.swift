//
//  MarkerInfo.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/22.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class MarkerInfo: UIView {
  
  enum Constant {
    case like, likeFill
    
    var image: UIImage? {
      switch self {
      case .like: return UIImage(named: "Icon-Heart")
      case .likeFill: return UIImage(named: "Icon-Heart-Fill")
      default: return nil
      }
    }
  }
  
  @IBOutlet weak var contentsView: UIView!
  @IBOutlet weak var triangleView: UIImageView!
  
  @IBOutlet weak var stationNameLabel: UILabel!
  
  
  @IBOutlet weak var distanceTitleLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var parkingBicycleTitleLabel: UILabel!
  @IBOutlet weak var parkingBicycleLabel: UILabel!
  
  
  @IBOutlet weak var likeButton: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupUI()
  }
  
  func setupUI() {
    if let markerInfoView = self.loadNib() {
      markerInfoView.frame = self.bounds
      self.addSubview(markerInfoView)
    }
    
    contentsView.layer.cornerRadius = 30
    contentsView.layer.masksToBounds = true
    contentsView.layer.applyShadow()
    triangleView.layer.applyShadow(x: 0, y: 3)
    
    stationNameLabel.text = "정류장"
    stationNameLabel.adjustsFontSizeToFitWidth = true
    stationNameLabel.font = AppTheme.font.custom(size: 15)
    stationNameLabel.textColor = AppTheme.color.blueMagenta
    
    distanceTitleLabel.text = "거리"
    distanceTitleLabel.textColor = AppTheme.color.gray
    distanceTitleLabel.font = AppTheme.font.custom(size: 11)

    distanceLabel.text = "0m"
    distanceLabel.textColor = AppTheme.color.main
    distanceLabel.font = AppTheme.font.custom(size: 14)
    
    parkingBicycleTitleLabel.text = "대여 가능 수"
    parkingBicycleTitleLabel.textColor = AppTheme.color.gray
    parkingBicycleTitleLabel.font = AppTheme.font.custom(size: 11)
    
    parkingBicycleLabel.text = "0대"
    parkingBicycleLabel.textColor = AppTheme.color.main
    parkingBicycleLabel.font = AppTheme.font.custom(size: 14)
  
    likeButton.setImage(Constant.like.image, for: .normal)
  }
  
  func configure(stationName: String, distance: Double, parkingBicycle: String) {
    self.stationNameLabel.text = stationName
    self.parkingBicycleLabel.text = parkingBicycle
    
    if distance > 1000 {
      self.distanceLabel.text = String(format: "%.1fkm", distance / 1000)
    } else {
      self.distanceLabel.text = String(format: "%dm", Int(distance))
    }
  }
}
