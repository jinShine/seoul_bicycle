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
//  func request<T: Decodable>(to router: SeoulBicycleAPI,
//                             decoder: T.Type,
//                             completion: @escaping (NetworkDataResponse) -> Void)
  func buildRequest<T: Decodable>(to router: SeoulBicycleAPI, decoder: T.Type) -> Single<NetworkDataResponse>
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
  
  func buildRequest<T: Decodable>(to router: SeoulBicycleAPI, decoder: T.Type) -> Single<NetworkDataResponse> {
    
    return self.provider.rx.request(router).flatMap { response in
      return Single.create { single -> Disposable in
        
        let requestStatusCode = NetworkStatusCode(rawValue: response.response?.statusCode ?? 0)
        
        guard requestStatusCode != .unauthorized && requestStatusCode != .forbidden else {
          single(.error(RequestError.invalidRequest))
          return Disposables.create()
        }
        
        response.data
        do {
          let result = try JSONDecoder().decode(decoder, from: response.data)
          single(.success(NetworkDataResponse(json: response.data, result: .success, error: response.)))
        } catch {
          
        }
        
        
        single(.success(NetworkDataResponse(json: response.data, result: .success, error: nil)))
        
        return Disposables.create()
      }
        
        
      
    }
    return self.provider.rx.request(router)
        .flatMap { response in
          return Single.create(subscribe: { single -> Disposable in
            let requestStatusCode = NetworkStatusCode(rawValue: response.response?.statusCode ?? 0)
            
            guard requestStatusCode != .unauthorized && requestStatusCode != .forbidden else {
              single(.error(RequestError.invalidRequest))
              return Disposables.create()
            }
            
            
            do {
              let model = try .data.decode(decoder)
            } catch {
              
            }
            
            
            single(.success(NetworkDataResponse(json: response.data, result: .success, error: nil)))

            return Disposables.create()
          })
        }
    
  }

//  func request<T: Decodable>(to router: SeoulBicycleAPI,
//                             decoder: T.Type,
//                             completion: @escaping (NetworkDataResponse) -> Void) {
//    provider.request(router) { response in
//      switch response {
//      case .success(let result):
//        do {
//          let model = try result.data.decode(decoder)
//          completion(NetworkDataResponse(json: model, result: .success, error: nil))
//        } catch {
//          let errorJsonData = result.data
//          completion(NetworkError.transform(jsonData: errorJsonData))
//        }
//      case .failure(let error):
//        let errorJsonData = error.response?.data
//        completion(NetworkError.transform(jsonData: errorJsonData))
//      }
//    }
//  }
}
