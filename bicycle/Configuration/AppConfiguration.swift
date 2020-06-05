//
//  AppConfiguration.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/06.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

struct AppConfiguration {
    
    var configurations: [AnyHashable: Any]?
    
    private enum Keys: String {
        case configuration = "ApplicationConfiguration"
    }
    
    mutating func setup() {
        self.configurations = self.getConfigurations()
    }
    
    var scheme: String? {
        return Bundle.main.infoDictionary?[Keys.configuration.rawValue] as? String
    }
    
    private func getConfigurations() -> [AnyHashable: Any]? {
        let fileName = "AppConfiguration"
        let fileExtension = "plist"
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension),
            let configurations = NSDictionary(contentsOfFile: filePath) as? [AnyHashable: Any],
            let scheme = self.scheme,
            let bundleConfig = configurations[scheme] as?  [AnyHashable: Any] else {
                return nil
        }
        
        return bundleConfig
    }
    
    var appVersion: String {
        let appVersion = AppInfo.version
        let buildVersion = AppInfo.buildVersion
        let release = "Release"
        guard let scheme = self.scheme,
            scheme.contains(release) == false else {
                return appVersion
        }
        
        
        return "\(appVersion).\(buildVersion)(\(scheme))"

    }

    var appInfo: String {
        let version = self.appVersion
        let modelName = UIDevice.current.model
        return "platform: iOS\ndevice: \(modelName)\nos_version: \(systemVersion)\nbicycle_version: \(version)"
    }
    
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
}

// MARK:- Current static instance

extension AppConfiguration {
    
    private static var instance: AppConfiguration!
    static func current() -> AppConfiguration {
        if instance == nil {
            instance = AppConfiguration()
            instance.setup()
        }
        return instance
    }
}

