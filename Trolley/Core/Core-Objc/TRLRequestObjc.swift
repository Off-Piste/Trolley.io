//
//  TRLRequestObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation
import PromiseKit

@available(swift, introduced: 1.0, obsoleted: 1.0)
public extension TRLRequest {
    
    /// Obj-C Progress Method
    ///
    /// - Note:
    /// Due to `breaking` changes, and that I can't send return 
    /// Networkable to force you call your response after this
    /// we had to add dataResponse to this method
    @objc(progressWithQueue:handler:response:)
    func progress(
        queue: DispatchQueue,
        progressHandler handler: @escaping (Progress) -> Void,
        dataResponse block: @escaping (Data?, Error?) -> Void
        )
    {
        self.dataRequest.downloadProgress(queue: queue) { handler($0) }
        self.responseData { block($0.0, $0.1) }
    }
    
    /// @objc version of `responseData() -> Promise<Data>`
    ///
    /// - Returns: Returns Any Promise
    @objc(responseData)
    func responseDataPromise() -> AnyPromise {
        return AnyPromise(responseData())
    }
    
}
