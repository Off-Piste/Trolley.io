//
//  URL+Ext.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation

extension String {
    
    static func createURL(isLocal: Bool, base: String, route: String, key: String) -> String {
        let http: String = (isLocal ? "http://" : "https://")
        return http + base + "/" + route + kKeyQuery + key
    }
    
}

extension URL {
    
    init?(baseURL: String, route: String, key: String) {
        let url = String.createURL(
            isLocal: _TRLInternalManager.shared.isLocal,
            base: baseURL,
            route: route,
            key: key
        )
        
        self.init(string: url)
    }
    
    
}
