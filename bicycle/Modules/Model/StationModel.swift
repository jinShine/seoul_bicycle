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

struct Station: Decodable, Equatable {
  var id: Int?
  var rackTotCnt: String        // 거치대개수
  var stationName: String       // 대여소이름
  var parkingBikeTotCnt: String // 자전거주차총건수
  var shared: String            // 거치율
  var stationLatitude: String   // 위도
  var stationLongitude: String  // 경도
  var stationId: String         // 대여소ID
  var distacne: Double?
  var like: Bool? = false
}

func == (lhs: Station, rhs: Station) -> Bool {
    return lhs.id == rhs.id
}

extension Station: Persistable {
  
  var identity: String {
    return "id"
  }
  
  public static var entityName: String {
    return "Station"
  }

  static var primaryAttributeName: String {
    return "id"
  }
  
  init(entity: NSManagedObject) {
    id = entity.value(forKey: "id") as? Int
    stationName = entity.value(forKey: "name") as! String
    parkingBikeTotCnt = entity.value(forKey: "parkingCount") as! String
    stationLatitude = entity.value(forKey: "latitude") as! String
    stationLongitude = entity.value(forKey: "longitude") as! String
    distacne = entity.value(forKey: "distance") as? Double
    rackTotCnt = entity.value(forKey: "rackCount") as! String
    shared = entity.value(forKey: "shared") as! String
    stationId = entity.value(forKey: "stationId") as! String
    like = entity.value(forKey: "like") as? Bool
  }

  func update(_ entity: NSManagedObject) {
    entity.setValue(id, forKey: "id")
    entity.setValue(stationName, forKey: "name")
    entity.setValue(parkingBikeTotCnt, forKey: "parkingCount")
    entity.setValue(stationLatitude, forKey: "latitude")
    entity.setValue(stationLongitude, forKey: "longitude")
    entity.setValue(distacne, forKey: "distance")
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
