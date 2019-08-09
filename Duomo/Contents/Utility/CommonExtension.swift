//
//  CommonExtension.swift
//  FoodFlyUserApp
//
//  Created by Seungjin on 25/07/2019.
//  Copyright © 2019 Jinnify. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import MapKit


//MARK: - UIStroyBoard

extension UIStoryboard {
	public class func create<T: UIViewController> (_: T.Type,
												   name: String = "Main",
												   bundle: Bundle? = nil,
												   identifier: String? = nil ) -> T {
		let storyboard = self.init(name: name, bundle: bundle)
		
		let withIndentifier = identifier ?? T.description().components(separatedBy: ".").last!
		return (storyboard.instantiateViewController(withIdentifier: withIndentifier) as? T)!
	}
}


//MARK: - UIAlertController

extension UIAlertController {
	static func make(title: String? = nil,
					 message: String? = nil,
           style: UIAlertController.Style,
					 ok: String? = nil,
					 okClosure: ((UIAlertAction) -> Void)? = nil,
					 cancel: String? = nil,
					 cancelClosure: ((UIAlertAction) -> Void)? = nil,
					 sheet: UIAlertAction...) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		
		if ok != nil {
			alert.addAction(UIAlertAction(title: ok, style: .default, handler: okClosure))
		}
		
		if cancel != nil {
			alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelClosure))
		}
		
		for value in sheet {
			alert.addAction(value)
		}
		return alert
	}
	
	func alertShow(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil ) {
		viewController.present(self, animated: animated, completion: completion)
	}
}


//MARK: - 스트링 로컬라이제이션 적용
extension String {
  
  var localize: String {
    return NSLocalizedString(self, comment: self)
  }
  
  // E-mail address validation
  func validateEmail() -> Bool {
    let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
    
    let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: self)
  }
  
  // Password validation
  func validatePassword() -> Bool {
    let passwordRegEx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$&*]).{8,16}$"
    
    let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return predicate.evaluate(with: self)
  }
  
}

//MARK: - UIImage
extension UIImage {
  func resize(to size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    self.draw(in: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
    let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizeImage
  }
}

//MARK: - UIColor
extension UIColor {
  convenience init(hex: String) {
    let hexStr: NSString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
    let scan = Scanner(string: hexStr as String)
    
    if hexStr.hasPrefix("#") {
      scan.scanLocation = 1
    }
    
    var color: UInt32 = 0
    scan.scanHexInt32(&color)
    
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: 1)
  }
  
  func toHexStr() -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return NSString(format: "#%06x", rgb) as String
  }
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat? = nil) {
    self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a ?? 255 / 255)
  }
}

extension UIButton {
  
  func isActivate(by state: Bool) {
    
    self.isEnabled = state
    
    if state {
      self.setTitleColor(UIColor.white, for: .normal)
    } else {
      self.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .disabled)
    }
    
  }
  
}
