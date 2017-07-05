//
//  TRLUtilities.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation
import Alamofire

func createError(_ reason: String) -> Error {
    return NSError(
        domain: "io.trolley.database",
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: reason]
    ) as Error
}

struct TRLUtilities {
    
    static var singleton = TRLUtilities()
    
    fileprivate var kRequiredPath: String = "API"
    
    /// (Host, Namespace, Secure, URL?)
    typealias URLReturn = (String, String, Bool, URL?)
    
    /// The Method to split down the URL to get its parts
    ///
    /// - Parameter url: The URL to be split up and checked
    /// - Returns: (Host, Namespace, Secure, URL?)
    /// - Throws: An Error, mainly invalid URL
    func split(_ url: URLConvertible) throws -> URLReturn {
        let stringURL = try url.asURL().absoluteString
        return try self._split(stringURL)
    }
    
    /// Method to valid the url and check it contains the right
    /// APIKey, this should never fail but will soon move the fatalErrors
    /// to actual errors and maybe have a docatch system in place
    ///
    /// - Parameters:
    ///   - url: The URL making the calls
    ///   - APIKey: The URL key that the url is set to contain
    func validate(_ url: ParsedURL, key APIKey: String) throws {
        if url.url == nil { throw createError("No request URL") }
        let (_, _, _, _) = try self.split(url)
        let path = url.url!.path
        
        if !self.checkForAPIInPath(path) {
            throw createError("No request /API in the request")
        }
        
        if try checkAPIKey(APIKey, in: path) { return }
        else { throw createError("No/Invalid API Key") }
    }

    
}

private extension TRLUtilities {

    func _split(_ urlString: String) throws -> URLReturn {
        guard let url = URL(string: urlString),
            let comp = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let scheme = comp.scheme,
            let host = comp.host
            else { throw createError("Invalid URL \(urlString)") }
        
        let (namespace, secure) = try self._stripURLForNamespaceAndSecure(host: host, scheme: scheme)
        return (host, namespace, secure, url)
    }
    
    func _stripURLForNamespaceAndSecure(host: String, scheme: String) throws -> (String, Bool) {
        let secure: Bool
        var namespace: String
        
        // Change this if the URL changes
        var parts: [String] = host.components(separatedBy: ".")
        if parts.count == 1 { // for localhost connections
            let colonIndex: Int? = (parts[0] as NSString).range(of: ":").location
            if colonIndex != NSNotFound {
                // we have a port, use the provided scheme
                secure = (scheme == "https")
            } else {
                // the sever isn't accectping SSL requests yet
                secure = (scheme == "https") /* true */
            }
            
            namespace = parts[0].lowercased()
        } else if parts.count == 5 {
            let colonIndex: Int? = (parts[2] as NSString).range(of: ":").location
            if colonIndex != NSNotFound {
                // we have a port, use the provided scheme
                secure = (scheme == "https")
            } else {
                secure = true
            }
            
            if parts.contains("www") {
                let index = parts.index { $0 == "www" }!
                namespace = parts[index + 1].lowercased()
            } else {
                namespace = parts[0].lowercased()
            }
        } else {
            throw createError("Invalid URL")
        }
        
        return (namespace, secure)

    }
}

private extension TRLUtilities {
    
    /// Method to check the path for /API/ or /API
    func checkForAPIInPath(_ path: String) -> Bool {
        var mutatingPath: String
        
        if (path.characters.first == "/") { mutatingPath = (path as NSString).substring(from: 1) }
        else { mutatingPath = path }
        
        let slashIndex = (mutatingPath as NSString).range(of: "/").location
        if slashIndex != NSNotFound {
            mutatingPath = (mutatingPath as NSString).substring(to: slashIndex)
            if mutatingPath != self.kRequiredPath { return false }
            else { return true }
        } else {
            if mutatingPath != self.kRequiredPath { return false }
            else { return true }
        }
    }
    
    /// Method to check the API in the path
    func checkAPIKey(_ APIKey: String, in path: String) throws -> Bool {
        var mutatingPath: String
        
        if (path.characters.first == "/") { mutatingPath = (path as NSString).substring(from: 1) }
        else { mutatingPath = path }
        
        // Should never fail as a previous check checks for this
        var slashIndex = (mutatingPath as NSString).range(of: "/").location
        mutatingPath = (mutatingPath as NSString).substring(from: slashIndex + 1)
        
        // Checks the API Key
        let key: String
        if APIKey.isEmpty { throw createError("API Key is rquired for calls to the database") }
        slashIndex = (mutatingPath as NSString).range(of: "/").location
        if slashIndex == NSNotFound { // the url is only "API/id"
            key = mutatingPath
        } else {
            key = (mutatingPath as NSString).substring(to: slashIndex)
        }
        
        if key != APIKey { return false }
        return true
    }
}
