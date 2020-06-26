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
  case viewDismiss
  
  var name: Notification.Name {
    switch self {
    case .viewDismiss: return Notification.Name("viewDismiss")
    }
  }
}
