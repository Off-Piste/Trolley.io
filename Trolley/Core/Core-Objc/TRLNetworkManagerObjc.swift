//
//  TRLNetworkManagerObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation
import Alamofire

@available(swift, introduced: 1.0, obsoleted: 1.0)
public extension TRLNetworkManager {
    
    @objc func get(
        _ route: String,
        with parameters: Dictionary<String, AnyObject>?,
        headers: Dictionary<String, String>?
        ) -> TRLRequest
    {
        let encoding: ParameterEncoding = URLEncoding.queryString
        return self.network.get(route, with: parameters, encoding: encoding, headers: headers)
    }
    
    @objc func getItem(
        withID id: String,
        inDatabase route: String,
        with parameters: Dictionary<String, AnyObject>?,
        headers: Dictionary<String, String>?
        ) -> TRLRequest
    {
        let encoding: ParameterEncoding = URLEncoding.queryString
        let route = String.urlRoute(for: route, id)
        return self.network.get(route, with: parameters, encoding: encoding, headers: headers)
    }
    
}

