//
//  Logger.swift
//  Pods
//
//  Created by Harry Wright on 06.04.17.
//
//

import Foundation
import Dispatch

func +(lhs: String, rhs: Any) -> String {
    return lhs + String(describing: rhs)
}

func +(lhs: Any, rhs: String) -> String {
    return String(describing: lhs) + rhs
}

/// Required to be global to set as a default
/// Person Preference. I prefer english -> d/m/y
public var dateFormat: String = "dd-MM-yyyy hh:mm:ss ZZZ"

fileprivate extension String {
    
    /// Static `Singleton` that holds an empty string.
    ///
    /// This is used for a default paramter in the logger
    static var `default` = ""
    
}

extension Date {

    /// A `String` property of a formated `Date`, 
    /// formats it for `self`
    var string: String {
        return self.format(for: self)
    }
    
    /// The method to format the date, the user should override `dateFormat` 
    /// to change the format style
    ///
    /// - Parameters:
    ///   - date: The date to the formatted
    ///   - style: The `DateFormatter` date format
    /// - Returns: The `String` value
    func format(for date: Date, withStyle style: String = dateFormat) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = style
        return "\(formatter.string(from: date))"
    }
    
}

// MARK: CUSTOM DEBUG FLAG
fileprivate let isInDebugMode: Bool = true

/** 
 New and improved Log tool.
 
 Removes cluttered code and annoying issues I had, currently
 only supports Infomation calls, error calls, and debug calls.
 
 - Information:
 These will be anything that is sent to the user, i.e
 Missing plist items or if the API key is wrong.
 
 - Error:
 For when an error is produced in our code, helpful for testing.
 
 - Debug: For testing the code, posting details that wont be used or
 known by the end user. `isInDebugMode` will be set to false upon full
 release
 */
struct Log {
    
    fileprivate enum LogType: String {
        case `default` = ""
        case error = "ERROR"
        case debug = "DEBUG"
        
        var string: String {
            return (self.rawValue == "" ? "" : " [\(self.rawValue)] " )
        }
    }
    
    static fileprivate func console(
        _ items: String,
        _ timer: String,
        _ source: String = .default,
        _ type: Log.LogType = .default
        )
    {
        print("[\(timer)]\(type.string)\(source.isEmpty ? "" : " \(source)") [Trolley] \(items)")
    }
    
}

/**
 
 */
extension Log {
    
    static func debug(
        _ items: Any...,
        showThread: Bool = false,
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        if !isInDebugMode { return }
        let strItems = self.sortVaradicItems(items)
        let strSource = self.createSourceString(showThread, file, function, line)
        
        self.console(strItems, Date().string, strSource, .debug)
    }
    
    static func info(
        _ items: Any...,
        showSource: Bool = false,
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        let strItems = self.sortVaradicItems(items)
        let date = Date().string
        
        if showSource {
            self.console(strItems, date, createSourceString(false, file, function, line))
        } else {
            self.console(strItems, date)
        }
    }
    
    static func error(
        _ items: Any...,
        showSource: Bool = false,
        showThread: Bool = false,
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        let strItems = self.sortVaradicItems(items)
        let date = Date().string
        
        if showSource {
            self.console(strItems, date, createSourceString(showThread, file, function, line), .error)
        } else {
            self.console(strItems, date, .default, .error)
        }
    }
}

/**
 
 */
extension Log {

    static fileprivate func sortVaradicItems(_ items: [Any]) -> String {
        var stringValue = String()
        for (index, item) in items.enumerated() {
            if items.count == 1 || index == (items.count - 1) { stringValue.append("\(item)"); break }
            stringValue.append("\(item)\(" ")")
        }
        
        return stringValue
    }
    
    static fileprivate func createSourceString(
        _ showThread: Bool,
        _ file: NSString,
        _ function: StaticString,
        _ line: Int
        ) -> String
    {
        var stringValue = String()
        let threadText = (showThread) ? ":\(Thread.current)" : ""
        
        stringValue.append(
            "[" +
                "\(file.lastPathComponent):" +
                "\(function):" +
                "\(line)" +
                threadText +
            "]"
        )
        return stringValue
    }
    
}
