//
//  TRLUtil+Alamofire.swift
//  Pods
//
//  Created by Harry Wright on 16.06.17.
//
//

import Foundation
import Alamofire

extension URLConvertible {
    
    var string: String {
        do {
            return try self.asURL().absoluteString
        } catch  {
            return ""
        }
    }
}

extension TRLUtilities {
    
    func parseURL(_ url: URLConvertible, checkingForError check: Bool = false) -> ParsedURL {
        return self.parseURL(url.string, checkingForError: check)
    }
    
}

extension ParsedURL : URLConvertible {
    
    func asURL() throws -> URL {
        guard let url = self.requestUrl else { throw AFError.invalidURL(url: self) }
        return url
    }
    
}
