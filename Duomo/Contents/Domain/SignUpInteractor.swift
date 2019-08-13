//
//  SignUpInteractor.swift
//  Duomo
//
//  Created by Seungjin on 07/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import FirebaseAuth
import FirebaseFirestore

protocol SignUpUseCase {
  func signup(name: String,
              email: String,
              password: String) -> Observable<SignUpErrors?>
}

final class SignUpInteractor: SignUpUseCase {
  func signup(name: String,
              email: String,
              password: String) -> Observable<SignUpErrors?> {
    
    return Observable<SignUpErrors?>.create { (observer) -> Disposable in
      Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        
        if let error = error {
          ELog(error: error)
          observer.onNext(SignUpErrors.alreadyRegister)
          return
        }
        DLog("SignUp Success!")
        
        guard let uid = result?.user.uid else { return }
        let data = [uid: ["name": name,
                          "email": email,
                          "token": uid]]
        
        App.firestore.db
          .collection("users")
          .addDocument(data: data, completion: { error in
            
            if let error = error {
              ELog(error: error)
              // DB 저장중 에러나면 계정 생성 삭제
              observer.onNext(SignUpErrors.dbError)
              Auth.auth().currentUser?.delete(completion: nil)
              
              return
            }
            
            observer.onNext(nil)
            observer.onCompleted()
            DLog("Data Save Success!")
          })
      }
      
      return Disposables.create ()
    }
  }
}
