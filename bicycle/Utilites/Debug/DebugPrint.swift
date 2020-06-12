//
//  DebugPrint.swift
//  bicycle
//
//  Created by Jinnify on 2020/06/12.
//  Copyright © 2020 Jinnify. All rights reserved.
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

//MARK:- Log

public func DLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
  print("📣 [\(filename(file))]\(functionName(function))(\(line)): \(message)")
}
#endif
