//
//  UserAnnotation.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import MapKit

class UserAnnotation: NSObject, MKAnnotation {
  var title: String?
  let subtitle: String?
  let coordinate: CLLocationCoordinate2D
  
  init(title: String? = nil, subtitle: String? = nil, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
  }
}
