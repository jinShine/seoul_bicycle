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

struct NetworkError {

  let statusCode: Int
  let message: String

  static func transform(jsonData: Data?) -> NetworkDataResponse {

    do {
      let result = try JSONDecoder().decode(SeoulBicycleErrorModel.self, from: jsonData ?? Data())
      DLog(result)
      return NetworkDataResponse(json: nil,
                                 result: .failure,
                                 error: NetworkError(statusCode: result.statusCode, message: result.message))
    } catch {
      DLog("Decodable Error")
      return NetworkDataResponse(json: nil,
                                 result: .failure,
                                 error: NetworkError(statusCode: 0, message: "Decodable Error"))
    }
  }
}
