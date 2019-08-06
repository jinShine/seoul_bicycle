//
//  DebugPrint.swift
//  Duomo
//
//  Created by Seungjin on 06/08/2019.
//  Copyright © 2019 jinnify. All rights reserved.
//

import Foundation

#if DEBUG
private func filename(_ path: String) -> String {
  guard let filename = path.split(separator: "/").last else { return path }
  return String(filename.prefix(upTo: filename.index(filename.endIndex, offsetBy: -6)))
}

private func functionName(_ function: String) -> String {
  guard let functionName = function.split(separator: "(").first else { return function }
  return String(functionName)
}

public func DLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
  print("📣 [\(filename(file))]\(functionName(function))(\(line)): \(message)")
}

public func ELog(error: Error, file: String = #file, function: String = #function, line: Int = #line) {
  print("🚫 [\(filename(file))]\(functionName(function))(\(line)): \(error.localizedDescription)")
}

public func ELog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
  print("🚫 [\(filename(file))]\(functionName(function))(\(line)): \(message)")
}
#endif
