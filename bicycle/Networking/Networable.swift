//
//  Networable.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/02.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift
import Moya


//protocol Networkable {
//  func buildRequest(to router: SeoulBikeAPI) -> Single<NetworkDataResponse>
//  func buildRequest(to router: SeoulOpenAPI) -> Single<NetworkDataResponse>
//}
//
//extension Networkable {
//  
//  func buildRequest(to router: SeoulBikeAPI) -> Single<NetworkDataResponse> {
//    return Single.just(NetworkDataResponse(jsonData: nil))
//  }
//  
//  func buildRequest(to router: SeoulOpenAPI) -> Single<NetworkDataResponse> {
//    return Single.just(NetworkDataResponse(jsonData: nil))
//  }
//}


protocol Networkable {
  associatedtype TargetType
  func buildRequest(to router: TargetType) -> Single<NetworkDataResponse>
}
