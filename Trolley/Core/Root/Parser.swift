//
//  Parser.swift
//  Pods
//
//  Created by Harry Wright on 24.05.17.
//
//

import Foundation

struct ParserError {
    
    enum error: Error {
        case dataIsNil
        case pathCannotBeFound(forResource: String)
        
        var localizedDescription: String {
            switch self {
            case .dataIsNil :
                return "The data cannot be read by the file manager"
            case .pathCannotBeFound(let resource) :
                return "The path for the resource: \(resource) cannot be found"
            }
        }
    }
}

typealias PError = ParserError.error
typealias PlistFormat = PropertyListSerialization.PropertyListFormat

class Parser {
    
    var items = [String : Any]()
    
    init(forResouceName name: String, ofType type: String) throws {
        guard let bundle = Bundle.main.path(forResource: name, ofType: type) else {
            throw PError.pathCannotBeFound(forResource: name)
        }
        
        let plistParser = try PLISTParser(contentsOfURL: bundle)
        self.items = plistParser.plist
    }
}

class PLISTParser {
    
    private(set) var plist = [String: AnyObject]() {
        didSet {
            self.headers = headers(fromXML: self.plist)
        }
    }
    
    private(set) var headers: [String] = []
    
    private init(xmlData: Data?, format: PlistFormat) throws {
        if let data = xmlData {
            var format = format
            
            plist = try PropertyListSerialization
                .propertyList(
                    from: data,
                    options: .mutableContainersAndLeaves,
                    format: &format) as! [String : AnyObject]
        } else {
            throw PError.dataIsNil
        }
    }
    
    public convenience init(contentsOfURL url: String) throws {
        let propertyListForamt: PlistFormat = .xml
        let plistXML = FileManager.default.contents(atPath: url)
        try self.init(xmlData: plistXML, format: propertyListForamt)
    }
    
    private func headers(fromXML xml: [String : AnyObject]) -> [String] {
        var lines = [String]()
        for (index, _) in self.plist {
            lines.append(index)
        }
        
        return lines
    }
}

