//
//  FindPasswordInteractor.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/09.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import FirebaseAuth

protocol FindPasswordUseCase {
  func sendPasswordReset(forEmail: String) -> Single<FindPasswordError?>
}

final class FindPasswordInteractor: FindPasswordUseCase {
  func sendPasswordReset(forEmail: String) -> Single<FindPasswordError?> {
    return Single<FindPasswordError?>.create(subscribe: { (single) -> Disposable in
      
      Auth.auth().sendPasswordReset(withEmail: forEmail, completion: { error in
        if let error = error as NSError? {
          single(.error(FindPasswordError.error(for: error.code)))
          ELog(error)
          return
        }

        single(.success(nil))
        DLog("비밀번호 재설정 메일 전송 성공")
      })
      
      return Disposables.create()
    })
  }
  
  
}
