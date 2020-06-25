//
//  StationModel.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import CoreData
import RxCoreData
import RxDataSources

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
  
  enum CodingKeys: String, CodingKey {
    case code = "CODE"
    case message = "MESSAGE"
  }
}

struct Station: Decodable {
  var rackTotCnt: String        // 거치대개수
  var stationName: String       // 대여소이름
  var parkingBikeTotCnt: String // 자전거주차총건수
  var shared: String            // 거치율
  var stationLatitude: String   // 위도
  var stationLongitude: String  // 경도
  var stationId: String         // 대여소ID
  var distance: String?
  var like: Bool? = false
  
  init() {
    rackTotCnt = ""
    stationName = ""
    parkingBikeTotCnt = ""
    shared = ""
    stationLatitude = ""
    stationLongitude = ""
    stationId = ""
    distance = ""
    like = false
  }
}

func == (lhs: Station, rhs: Station) -> Bool {
  return lhs.stationId == rhs.stationId
}

extension Station: Equatable, IdentifiableType { }

extension Station: Persistable {
  
  var identity: String {
    return stationId
  }
  
  public static var entityName: String {
    return "Station"
  }
  
  static var primaryAttributeName: String {
    return "stationId"
  }
  
  init(entity: NSManagedObject) {
    stationName = entity.value(forKey: "name") as! String
    parkingBikeTotCnt = entity.value(forKey: "parkingCount") as! String
    stationLatitude = entity.value(forKey: "latitude") as! String
    stationLongitude = entity.value(forKey: "longitude") as! String
    distance = entity.value(forKey: "distance") as? String
    rackTotCnt = entity.value(forKey: "rackCount") as! String
    shared = entity.value(forKey: "shared") as! String
    stationId = entity.value(forKey: "stationId") as! String
    like = entity.value(forKey: "like") as? Bool
  }
  
  func update(_ entity: NSManagedObject) {
    entity.setValue(stationName, forKey: "name")
    entity.setValue(parkingBikeTotCnt, forKey: "parkingCount")
    entity.setValue(stationLatitude, forKey: "latitude")
    entity.setValue(stationLongitude, forKey: "longitude")
    entity.setValue(distance, forKey: "distance")
    entity.setValue(rackTotCnt, forKey: "rackCount")
    entity.setValue(shared, forKey: "shared")
    entity.setValue(stationId, forKey: "stationId")
    entity.setValue(like, forKey: "like")
    
    do {
      try entity.managedObjectContext?.save()
    } catch {
      print(error)
    }
  }
}
