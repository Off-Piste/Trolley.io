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
    
    private var kRequiredPath: String = "API"
    
    typealias URLReturn = (String, String, Bool, String, URL?)
    
    /// <#Description#>
    ///
    /// - Parameter url: <#url description#>
    /// - Returns: (Host, Namespace, Secure, Path)
    func split(url: String) -> URLReturn {
        guard let url = URL(string: url),
            let comp = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let scheme = comp.scheme,
            let host = comp.host
            else { return ("", "", false, "", nil) }
        
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
                secure = true
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
            return ("", "", false, "", url)
        }
        
        return (host, namespace, secure, comp.path, url)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - checkingForError: <#checkingForError description#>
    /// - Returns: <#return value description#>
    func parseURL(_ url: String, checkingForError: Bool = false) -> ParsedURL {
        let (host, namespace, secure, path, url) = self.split(url: url)
        
        if host.isEmpty && namespace.isEmpty && secure == false { fatalError("Invalid URL") }
        if checkingForError {
            var mutatingPath = (path as NSString).substring(from: 1)
            let slashIndex = (mutatingPath as NSString).range(of: "/").location
            if slashIndex != NSNotFound {
                mutatingPath = (mutatingPath as NSString).substring(to: slashIndex)
                if mutatingPath != self.kRequiredPath { fatalError("Invalid URL") }
            } else {
                if mutatingPath != self.kRequiredPath { fatalError("Invalid URL") }
            }
        }
        
        let info = TRLNetworkInfo(host: host, namespace: namespace, secure: secure, url: url)
        return ParsedURL(networkInfo: info)
    }
    
    func parseURL(_ url: URL, checkingForError check: Bool = false) -> ParsedURL {
        return self.parseURL(url.absoluteString, checkingForError: check)
    }
    
    // May change this to use URLComponants
//    func parseURL(_ url: String) -> ParsedURL {
//        var mutatingURL = url
//        var scheme: String
//        var host: String
//        var secure: Bool
//        var namespace: String
//        var requiredPath: String
//        
//        // We need to get the scheme
//        let colonIndex = (mutatingURL as NSString).range(of: "//")
//        if colonIndex.location != NSNotFound {
//            scheme = (mutatingURL as NSString).substring(to: colonIndex.location - 1)
//            mutatingURL = (mutatingURL as NSString).substring(from: colonIndex.location + 2)
//        } else {
//            fatalError("Invalid URL")
//        }
//        
//        // Find the end of the host url
//        var slashIndex: Int = (mutatingURL as NSString).range(of: "/").location
//        if slashIndex == NSNotFound {
//            slashIndex = (mutatingURL as NSString).length
//        }
//        
//        // Set the host
//        host = (mutatingURL as NSString).substring(to: slashIndex).lowercased()
//        if slashIndex >= (mutatingURL as NSString).length {
//            mutatingURL = ""
//        } else {
//            mutatingURL = ((mutatingURL as NSString).substring(from: slashIndex + 1))
//        }
//        
//        // Checking for the parts inside the host url
//        var parts: [String] = host.components(separatedBy: ".")
//        if parts.count == 1 { // for localhost connections
//            let colonIndex: Int? = (parts[0] as NSString).range(of: ":").location
//            if colonIndex != NSNotFound {
//                // we have a port, use the provided scheme
//                secure = (scheme == "https")
//            } else {
//                secure = true
//            }
//            
//            namespace = parts[0].lowercased()
//        } else if parts.count == 5 {
//            let colonIndex: Int? = (parts[2] as NSString).range(of: ":").location
//            if colonIndex != NSNotFound {
//                // we have a port, use the provided scheme
//                secure = (scheme == "https")
//            } else {
//                secure = true
//            }
//            
//            if parts.contains("www") {
//                let index = parts.index { $0 == "www" }!
//                namespace = parts[index + 1].lowercased()
//            } else {
//                namespace = parts[0].lowercased()
//            }
//        } else {
//            fatalError("Invalid URL")
//        }
//        
//        // Checking the end path
//        slashIndex = (mutatingURL as NSString).range(of: "/").location
//        if slashIndex == NSNotFound {
//            fatalError("Missing the a path")
//        } else {
//            requiredPath = (mutatingURL as NSString).substring(to: slashIndex)
//        }
//        
//        if requiredPath != self.kRequiredPath { fatalError("/API is missing") }
//        
//        guard let url = URL(string: url) else {
//            fatalError("URL(string:) failed")
//        }
//        
//        let networkInfo = TRLNetworkInfo(host: host, namespace: namespace, secure: secure, url: url)
//        return ParsedURL(networkInfo: networkInfo)
//    }
    
}
