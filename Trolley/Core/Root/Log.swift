//
//  Logger.swift
//  Pods
//
//  Created by Harry Wright on 06.04.17.
//
//

import Foundation
import Dispatch
import asl

let kTrolleyVersionNumber: String = "0.1.0"

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

fileprivate extension Array {
    
    var filtered: [Element] {
        return self.filter{ ($0 is String) ? !($0 as! String).isEmpty : true }
    }
    
    var stringArray: [String] {
        return self.flatMap { ($0 as Any?) == nil ? "" : "\($0)" }
    }
    
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
internal var isInDebugMode: Bool = false

let TRLCoreLogger = Log("Core")
let TRLDatabaseLogger = Log("Database")
let TRLDefaultLogger = Log("")

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
    
    fileprivate var location: String
    
    fileprivate init(_ location: String) {
        self.location = location
    }
    
    fileprivate enum LogType: String {
        case `default` = ""
        case error = "ERROR"
        case debug = "DEBUG"
        case fatalError = "FATAL ERROR | FATAL ERROR"
        
        var string: String {
            return (self.rawValue == "" ? "" : " [\(self.rawValue)]" )
        }
    }
    
    fileprivate func console(
        _ items: String,
        _ timer: String,
        _ source: String = .default,
        _ type: Log.LogType = .default
        )
    {
        let name = (location.isEmpty) ? "Trolley" : "Trolley/\(location)"
        self.log("\(timer) [\(name)]\(type.string)\(source.isEmpty ? "" : " \(source)") \(items)")
    }
    
    fileprivate func log(_ value: String) {
        print(value)
    }
}

/**
 
 */
extension Log {
    
    func debug(
        _ items: Any...,
        showThread: Bool = false,
        separator: String = " ",
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        if !isInDebugMode { return }
        let strItems = self.sortVaradicItems(items, separator: separator)
        let strSource = self.createSourceString(showThread, file, function, line)
        
        self.console(strItems, Date().string, strSource, .debug)
    }
    
    func info(
        _ items: Any...,
        showSource: Bool = false,
        separator: String = " ",
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        let strItems = self.sortVaradicItems(items, separator: separator)
        let date = Date().string
        
        if showSource {
            self.console(strItems, date, createSourceString(false, file, function, line))
        } else {
            self.console(strItems, date)
        }
    }
    
    func error(
        _ items: Any...,
        showSource: Bool = true,
        showThread: Bool = false,
        separator: String = " ",
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        let strItems = self.sortVaradicItems(items, separator: separator)
        let date = Date().string
        
        if showSource {
            self.console(strItems, date, createSourceString(showThread, file, function, line), .error)
        } else {
            self.console(strItems, date, .default, .error)
        }
    }
    
    func fatalError(
        _ items: Any...,
        showSource: Bool = true,
        showThread: Bool = false,
        separator: String = " ",
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        let strItems = self.sortVaradicItems(items, separator: separator)
        let date = Date().string
        
        if showSource {
            self.console(strItems, date, createSourceString(showThread, file, function, line), .fatalError)
        } else {
            self.console(strItems, date, .default, .fatalError)
        }
    }
    
    func completeDebug(
        _ items: Any...,
        separator: String = " ",
        file: NSString = #file,
        function: StaticString = #function,
        line: Int = #line
        )
    {
        let strItems = self.sortVaradicItems(items, separator: separator)
        let date = Date().string
        
        self.log("\(date) [DEBUG] \(createSourceString(true, file, function, line)) [\(TRLAppEnviroment.current)] \(strItems)")
    }
}

/**
 
 */
extension Log {

    fileprivate func sortVaradicItems(_ items: [Any], separator: String) -> String {
        return items.filtered.stringArray.joined(separator: separator)
    }
    
    fileprivate func createSourceString(
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

/// Use me when just checking and don't require an crash
func _check(
    _ value: @autoclosure () -> Bool,
    _ message: String = "",
    _ file: NSString = #file,
    _ function: StaticString = #function,
    _ line: Int =  #line
    )
{
    if value() { return }
    TRLDefaultLogger.debug(
        "_check failed, please assess your code", message,
        showThread: false,
        separator: " ",
        file: file,
        function: function,
        line: line
    )
}

func _checkForEmpty<C: Collection>(
    _ value: C,
    _ message: String = "",
    _ file: NSString = #file,
    _ function: StaticString = #function,
    _ line: Int =  #line
    )
{
    _check(value.isEmpty, message, file, function, line)
}

func _checkForNotEmpty<C: Collection>(
    _ value: C,
    _ message: String = "",
    _ file: NSString = #file,
    _ function: StaticString = #function,
    _ line: Int =  #line
    )
{
    _check(!value.isEmpty, message, file, function, line)
}

func _checkForNil(
    _ value: Any?,
    _ message: String = "",
    _ file: NSString = #file,
    _ function: StaticString = #function,
    _ line: Int =  #line
    )
{
    _check(value == nil, message, file, function, line)
}

func _checkForNonNil(
    _ value: Any?,
    _ message: String = "",
    _ file: NSString = #file,
    _ function: StaticString = #function,
    _ line: Int =  #line
    )
{
    _check(value != nil, message, file, function, line)
}

/// Use me when wanting to use the assert,
func _assertCheck(
    _ value: @autoclosure () -> Bool,
    _ message: String...,
    _ file: StaticString = #file,
    _ line: UInt = #line
    )
{
    
    assert(value(), TRLDefaultLogger.sortVaradicItems(message, separator: " "), file: file, line: line)
}
