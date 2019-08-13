//
//  LoginInteractor.swift
//  Duomo
//
//  Created by Seungjin on 08/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import FirebaseAuth


protocol SignInUseCase {
  func login(email: String, password: String) -> Observable<SignInError?>
  func kakaoLogin() -> Observable<(NSError?, KOUserMe?)>
  func kakaoToken() -> String?
}

final class SignInInteractor: SignInUseCase {
  
  func login(email: String, password: String) -> Observable<SignInError?> {
    return Observable.create { (observer) -> Disposable in
      
      Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
        
        if let error = error as NSError? {
          ELog(error)
          observer.onNext(SignInError.error(for: error.code))
          return
        }
        
        DLog("Login Success!")
        observer.onNext(nil)
      })
      
      return Disposables.create()
    }
  }
  
  func kakaoLogin() -> Observable<(NSError?, KOUserMe?)> {
    return Observable<(NSError?, KOUserMe?)>.create({ (observer) -> Disposable in
      
      guard let session = KOSession.shared() else {
        return Disposables.create()
      }
      
      if session.isOpen() {
        session.close()
      }
      
      session.open { (error) in
        if !session.isOpen() {
          if let error = error as Error? {
            observer.onError(error)
            return
          }
        }
        
        DLog("Kakao Login Success!")
        
        KOSessionTask.userMeTask(completion: { (error, result) in
          if let error = error as NSError? {
            observer.onError(error)
            return
          }
          
          guard let uid = self.kakaoToken() else { return }
          let data = [uid: ["name": result?.nickname,
                            "email": result?.account?.email,
                            "token": uid]]
          
          App.firestore.create(collection: "users", data: data, completion: nil)
          
          
          DLog("Get Kakao User Info Success!")
          observer.onNext((nil, result))
          observer.onCompleted()
        })
      }
      
      return Disposables.create()
    })
    
  }
  
  func kakaoToken() -> String? {
    guard let session = KOSession.shared() else {
      return nil
    }

    let token = session.token?.accessToken
    
    return token
  }
}
