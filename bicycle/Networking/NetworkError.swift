//
//  NetworkError.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import Moya

enum NetworkStatusCode: Int {
  case unauthorized = 401
  case forbidden = 403
}
