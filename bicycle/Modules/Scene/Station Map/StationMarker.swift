//
//  StationMarker.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/18.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import NMapsMap

class StationMarker: NMFMarker {
  
  let stationCountLabel = UILabel()
  
  override init() {
    super.init()
    
    self.mapView?.addSubview(stationCountLabel)
    stationCountLabel.text = "123123"
//    iconImage = NMFOverlayImage(image: UIImage(named: "bike-marker")!)
  }
  
  

}
