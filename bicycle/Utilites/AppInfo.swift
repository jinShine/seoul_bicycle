//
//  AppInfo.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/06.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

struct AppInfo {
    
    static var version: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? ""
        return "\(version)"
    }
    
    static var buildVersion: String {
        let info = Bundle.main.infoDictionary
        let build = info?["CFBundleVersion"] as? String ?? ""
        return "\(build)"
        
    }
    
    static var appIdentifier: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }
}
