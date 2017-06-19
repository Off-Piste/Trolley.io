//
//  TRLUtilities.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation

struct TRLUtilities {
    
    static var singleton = TRLUtilities()
    
    fileprivate var kRequiredPath: String = "API"
    
    typealias URLReturn = (String, String, Bool, String, URL?)
    
    /// The method to split the URL down to its key
    /// components, using both URLComponents and
    /// `getNamspaceAndSecure(inHost:scheme:)`
    ///
    /// - Parameter url: The url as `String` to be split
    /// - Returns: `(Host, Namespace, Secure, Path, URL?)`
    func split(url: String) -> URLReturn {
        guard let url = URL(string: url),
            let comp = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let scheme = comp.scheme,
            let host = comp.host
            else { fatalError("Invalid URL") }
        
        let (namespace, secure) = self.getNamspaceAndSecure(inHost: host, scheme: scheme)
        return (host, namespace, secure, comp.path, url)
    }
    
    /// The method called to check the URL to make sure
    /// it is fit for API calls and consumption
    ///
    /// - Parameters:
    ///   - url: The URL making the calls
    ///   - checkingForError: Wether tha URL should be checked for any more errors
    /// - Returns: A new ParsedURL that has been checked out
    func parseURL(_ url: String, checkingForError: Bool = false) -> ParsedURL {
        let (host, namespace, secure, path, url) = self.split(url: url)
        
        if checkingForError {
            if !self.checkForAPIPath(inPath: path) { fatalError("Invalid API Path") }
        }
        
        let info = TRLNetworkInfo(host: host, namespace: namespace, secure: secure, url: url)
        return ParsedURL(networkInfo: info)
    }
    
    /// The method called to check the URL to make sure
    /// it is fit for API calls and consumption
    ///
    /// - Parameters:
    ///   - url: The URL making the calls
    ///   - checkingForError: Wether tha URL should be checked for any more errors
    /// - Returns: A new ParsedURL that has been checked out
    func parseURL(_ url: URL, checkingForError check: Bool = false) -> ParsedURL {
        return self.parseURL(url.absoluteString, checkingForError: check)
    }
    
    /// Method to valid the url and check it contains the right
    /// APIKey, this should never fail but will soon move the fatalErrors 
    /// to actual errors and maybe have a docatch system in place
    ///
    /// - Parameters:
    ///   - url: The URL making the calls
    ///   - APIKey: The URL key that the url is set to contain
    func validate(_ url: ParsedURL, key APIKey: String) {
        if url.requestUrl == nil { fatalError("Failed Validation Check 1 : No request URL") }
        let (_, _, _, path, _) = self.split(url: url.requestUrl!.absoluteString)
        if !self.checkForAPIPath(inPath: path) {
            fatalError("Failed Validation Check 2 : No request /API in the request")
        }
        
        if checkAPIKey(APIKey, in: path) { return }
        else { fatalError("Failed Validation Check 3 : No/Invalid API Key") }
    }
    
}

private extension TRLUtilities {
    
    /// Method to check the path for /API/ or /API
    func checkForAPIPath(inPath path: String) -> Bool {
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
    func checkAPIKey(_ APIKey: String, in path: String) -> Bool {
        var mutatingPath: String
        
        if (path.characters.first == "/") { mutatingPath = (path as NSString).substring(from: 1) }
        else { mutatingPath = path }
        
        // Should never fail as a previous check checks for this
        var slashIndex = (mutatingPath as NSString).range(of: "/").location
        mutatingPath = (mutatingPath as NSString).substring(from: slashIndex + 1)
        
        // Checks the API Key
        let key: String
        if APIKey.isEmpty { fatalError("API Key is rquired for calls to the database") }
        slashIndex = (mutatingPath as NSString).range(of: "/").location
        if slashIndex == NSNotFound { // the url is only "API/id"
            key = mutatingPath
        } else {
            key = (mutatingPath as NSString).substring(to: slashIndex)
        }
        
        if key != APIKey { return false }
        return true
    }

    
    /// Method to get both the namespace and secure from both the
    /// host and scheme
    func getNamspaceAndSecure(inHost host: String, scheme: String) -> (String, Bool) {
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
                secure = false
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
            fatalError("Invalid URL")
        }
        
        return (namespace, secure)
    }
    
    
}
