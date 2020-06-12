//
//  StationModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

struct RentStationStatus: Decodable {
  var status: StationStatus
  
  enum CodingKeys: String, CodingKey {
    case status = "rentBikeStatus"
  }
}

struct StationStatus: Decodable {
  var listTotalCount: Int
  var result: StationResult
  var row: [Station]
  
  enum CodingKeys: String, CodingKey {
    case listTotalCount = "list_total_count"
    case result = "RESULT"
    case row
  }
}

struct StationResult: Decodable {
  var code: String
  var message: String
}

struct Station: Decodable {
  var rackTotCnt: String        // 거치대개수
  var stationName: String       // 대여소이름
  var parkingBikeTotCnt: String // 자전거주차총건수
  var shared: String            // 거치율
  var stationLatitude: String   // 위도
  var stationLongitude: String  // 경도
  var stationId: String         // 대여소ID
}
