//
//  SeoulOpenAPIService.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

protocol SeoulOpenAPIProtocol {
  func buildRequest(to router: SeoulOpenAPI) -> Single<NetworkDataResponse>
}

struct SeoulOpenAPIService {
  
  static let sharedManager: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.headers = HTTPHeaders.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    configuration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    return Alamofire.Session(configuration: configuration)
  }()
}

extension SeoulOpenAPIService: SeoulOpenAPIProtocol {
  
  var provider: MoyaProvider<SeoulOpenAPI> {
    return MoyaProvider<SeoulOpenAPI>(endpointClosure: MoyaProvider.defaultEndpointMapping,
                                                 requestClosure: MoyaProvider<SeoulOpenAPI>.defaultRequestMapping,
                                                 stubClosure: MoyaProvider.neverStub,
                                                 callbackQueue: nil,
                                                 session: SeoulOpenAPIService.sharedManager,
                                                 plugins: [],
                                                 trackInflights: false)
  }
  
  func buildRequest(to router: SeoulOpenAPI) -> Single<NetworkDataResponse> {
    return self.provider.rx.request(router)
      .flatMap { response -> Single<NetworkDataResponse> in
        return Single.create(subscribe: { single -> Disposable in
          let requestStatusCode = NetworkStatusCode(rawValue: response.response?.statusCode ?? 0)

          guard requestStatusCode != .unauthorized && requestStatusCode != .forbidden else {
            single(.error(RequestError.invalidRequest))
            return Disposables.create()
          }

          single(.success(NetworkDataResponse(jsonData: response.data)))

          return Disposables.create()
        })
    }
  }
}
