//
//  Transitionable.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/18.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

protocol Transitionable {

  func pop(sender: UIViewController?, toRoot: Bool, animated: Bool)
  func dismiss(sender: UIViewController, animated: Bool, completion: (() -> Void)?)
  func show(scene: Navigator.Scene, sender: UIViewController?, animated: Bool, completion: (() -> Void)?)
  func push(scene: Navigator.Scene, sender: UINavigationController?, animated: Bool)
}
