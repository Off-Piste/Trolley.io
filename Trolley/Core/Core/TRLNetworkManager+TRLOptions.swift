//
//  TRLNetworkManager+TRLOptions.swift
//  Pods
//
//  Created by Harry Wright on 24.05.17.
//
//

import Foundation

extension TRLNetworkManager {
    
    convenience init(option: TRLOptions) throws {
        try self.init(option.url, key: option.merchantID)
    }
    
}
