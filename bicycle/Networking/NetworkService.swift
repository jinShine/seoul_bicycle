//
//  NetworkService.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import RxSwift
import Moya
import Alamofire

protocol Networkable {
  func buildRequest(to router: SeoulBicycleAPI) -> Single<NetworkDataResponse>
}

struct NetworkService: Networkable {
  
  static private let sharedManager: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.headers = HTTPHeaders.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    configuration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    return Alamofire.Session(configuration: configuration)
  }()
  
  private let provider: MoyaProvider<SeoulBicycleAPI> = {
    
    let provider = MoyaProvider<SeoulBicycleAPI>(endpointClosure: MoyaProvider.defaultEndpointMapping,
                                                 requestClosure: MoyaProvider<SeoulBicycleAPI>.defaultRequestMapping,
                                                 stubClosure: MoyaProvider.neverStub,
                                                 callbackQueue: nil,
                                                 session: sharedManager,
                                                 plugins: [],
                                                 trackInflights: false)
    return provider
  }()
  
  func buildRequest(to router: SeoulBicycleAPI) -> Single<NetworkDataResponse> {
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
