//
//  SeoulBikeInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/02.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift

//protocol SeoulBikeUseCase {
//  
//  func login(id: String, pw: String) -> Observable<Bool>
//}
//
//class SeoulBikeInteractor: SeoulBikeUseCase, AppGlobalRepositoryType {
//  
//  private var service: Networkable {
//    return appConstant.network
//  }
//
//  private func stationRequest(start: Int, last: Int) -> Single<RentStationStatus> {
//    return service.buildRequest(to: <#T##SeoulOpenAPI#>)
//      .map { response in
//        return try JSONDecoder().decode(RentStationStatus.self, from: response.jsonData ?? Data())
//    }
//    .catchError { error in
//      return Single.create { single -> Disposable in
//        single(.error(error))
//        return Disposables.create()
//      }
//    }
//  }
//  
//}
