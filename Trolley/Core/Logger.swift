//
//  Logger.swift
//  Pods
//
//  Created by Harry Wright on 06.04.17.
//
//

import Foundation
import Dispatch

/// Required to be global to set as a default
/// Person Preference. I prefer english -> d/m/y
public var dateFormat: String = "dd-MM-yyyy hh:mm:ss ZZZ"

internal class Logger {
    
    static var shouldLogEverything: Bool = true
    
    static var isInDebugMode: Bool = false
    
    static let queue = DispatchQueue(label: "Logger")
    
    internal enum logLevel: String {
        case error = "Error"
        case warning = "Warning"
        case fatalError = "Fatal Error"
        case info = "Infomation"
        case defaults = "defaults"
        
    }
    
    internal static func formatedDate() -> String {
        return self.format(for: Date())
    }
    
    internal static func format(for date: Date, withStyle style: String = dateFormat) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = style
        return "\(formatter.string(from: date))"
    }
    
    internal static func debug(
        _ info: Any? = nil,
        file: NSString = #file,
        function: StaticString = #function,
        line: Int32 = #line
        )
    {
        if !isInDebugMode { return }
        let frameworkName = "[DEBUG MODE]"
        let details = "File: \(file.lastPathComponent) Func: \(function) Line: \(line)"
        let printValue: String
        
        if info == nil {
            printValue = "\(frameworkName) | \(details)"
        } else {
            printValue = "\(frameworkName) | Info: \(info!) | \(details)"
        }
        
        queue.async {
            print(printValue)
        }
    }
    
    internal static func log(
        _ value: Any...,
        level: logLevel = .info,
        seperator: StaticString = " ",
        terminator: String = "\n",
        file: NSString = #file,
        function: StaticString = #function,
        line: Int32 = #line
        )
    {
        if !shouldLogEverything && level == .info { return }
        
        let date = formatedDate()
        let source = "Source -> File: [\(file.lastPathComponent)]; Function: [\(function)]; Line: [\(line)]"
        let frameworkName = "[PowerPlayFramework]"
        let priorityLevel = "Level: \(level.rawValue)"
        
        var stringValue = ""
        for (index, item) in value.enumerated() {
            if value.count == 1 || index == (value.count - 1) { stringValue.append("\(item)"); break }
            stringValue.append("\(item)\(seperator)")
        }
        
        var printValue: String
        if level == .info || level == .defaults {
            printValue = ("\(String(describing: date)) \(frameworkName) | \(stringValue)")
        } else if level == .warning || level == .error {
            printValue = ("WARNING! \(date) \(frameworkName) | \(priorityLevel) | \(source) | Cause: \(stringValue)")
        } else if level == .fatalError {
            printValue = ("CRASH!! WARNING!! \(date) \(frameworkName) | \(priorityLevel) | \(source) | Cause: \(stringValue)")
        } else {
            printValue = ("\(date) \(frameworkName) | \(priorityLevel) | \(source) | Cause: \(stringValue)")
        }
        
        queue.async {
            print(printValue, terminator: terminator)
        }
    }
}
