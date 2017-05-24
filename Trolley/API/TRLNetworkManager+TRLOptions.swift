//
//  TRLNetworkManager+TRLOptions.swift
//  Pods
//
//  Created by Harry Wright on 24.05.17.
//
//

import Foundation

extension TRLNetworkManager {
    
    init(option: TRLOptions) {
        self.init(withKey: option.merchantID, isLocal: true)
    }
    
}
