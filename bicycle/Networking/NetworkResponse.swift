//
//  NetworkResponse.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

enum NetworkResult {
  case success
  case failure
}

struct NetworkDataResponse {
  let json: Decodable?
  let result: NetworkResult
  let error: NetworkError?
}

enum RequestError: Error {
  case invalidRequest
}
