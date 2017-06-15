//
//  TRLNetworkManager+TRLOptions.swift
//  Pods
//
//  Created by Harry Wright on 24.05.17.
//
//

import Foundation

extension TRLNetwork {
    
    init(option: TRLOptions) {
        self.init(option.url, APIKey: option.merchantID)
    }
    
}
