//
//  SeoulBikeAPIInteractor.swift
//  bicycle
//
//  Created by Jinnify on 2020/07/05.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift

protocol SeoulBikeAPIUseCase {
  func login(id: String, pw: String) -> Single<Data?>
}

class SeoulBikeAPIInteractor: SeoulBikeAPIUseCase, AppGlobalRepositoryType {
  
  private var service: SeoulBikeAPIProtocol {
    return appConstant.seoulBikeNetwork
  }
  
  func login(id: String, pw: String) -> Single<Data?> {
    return service.buildRequest(to: .login(id: id, pw: pw))
      .map { $0.jsonData }
    .catchError { error in
      return Single.create { single -> Disposable in
        single(.error(error))
        return Disposables.create()
      }
    }
  }

}

