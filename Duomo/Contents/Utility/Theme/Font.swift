//
//  Font.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/09.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation

struct Font {
    
    func regular(size: CGFloat) -> UIFont {
      return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    func medium(size: CGFloat) -> UIFont {
      return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    func bold(size: CGFloat) -> UIFont {
      return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }

}
