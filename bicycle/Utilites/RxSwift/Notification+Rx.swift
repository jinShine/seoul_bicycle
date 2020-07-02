//
//  Notification+Rx.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/26.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import RxSwift

protocol NotificationCenterProtocol {
  var name: Notification.Name { get }
}

extension NotificationCenterProtocol {
  
  func addObserver() -> Observable<Any?> {
    NotificationCenter.default.rx.notification(self.name).map { $0.object }
  }
  
  func post(object: Any? = nil) {
    NotificationCenter.default.post(name: self.name, object: object, userInfo: nil)
  }
}

enum AppNotificationCenter: NotificationCenterProtocol {
  case stationDidReceive
  
  var name: Notification.Name {
    switch self {
    case .stationDidReceive: return Notification.Name("stationDidReceive")
    }
  }
  
  static func keyboardHeight() -> Observable<CGFloat> {
    return Observable.from([
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
          .map { notification -> CGFloat in (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0},
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
          .map { _ -> CGFloat in 0 }
      ]).merge()
  }

}
