//
//  Data+Decode.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

extension Data {

  func decode<T>(_ type: T.Type, decoder: JSONDecoder? = nil) throws -> T where T: Decodable {
    let decoder = decoder ?? JSONDecoder()
    return try decoder.decode(type, from: self)
  }
}
