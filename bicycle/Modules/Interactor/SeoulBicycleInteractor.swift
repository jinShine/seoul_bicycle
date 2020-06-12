//
//  SeoulBicycleInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift

protocol SeoulBicycleUseCase {
  
  func fetchBicycleList(start: Int, last: Int) -> Single<NetworkDataResponse>
}

class SeoulBicycleInteractor: SeoulBicycleUseCase {
  
  let network: Networkable
  
  init(network: Networkable) {
    self.network = network
  }
  
  func fetchBicycleList(start: Int, last: Int) -> Single<NetworkDataResponse> {
    return network.buildRequest(to: .bicycleList(start: start, last: last))
      .map { response in
        let model = try JSONDecoder().decode(RentStationStatus.self, from: response.jo)
        let result = NetworkDataResponse(json: response.json, result: <#T##NetworkResult#>, error: <#T##NetworkError?#>)
        return result
    }
  }
}
