//
//  SeoulBicycleErrorModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

struct SeoulBicycleErrorModel: Decodable {
  
  var statusCode: Int
  var message: String
}
