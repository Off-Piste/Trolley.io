/////////////////////////////////////////////////////////////////////////////////
//
//  Networkable.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 07.09.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

extension TRLURLDataRequest {

    @discardableResult
    @objc(response:)
    public func response(block: @escaping (Data?, Error?) -> Void) -> Self {
        return self.response(withQueue: nil, block: block)
    }

    @discardableResult
    @objc(responseWithQueue:block:)
    public func response(
        withQueue queue: DispatchQueue?,
        block: @escaping (Data?, Error?) -> Void
        ) -> Self
    {
        return self.__responseWithQueue(queue) { resp in
            block(resp.data, resp.error)
        }
    }

    @discardableResult
    @objc(__responseWithQueue:block:)
    public func __responseWithQueue(
        _ queue: DispatchQueue? = nil,
        block: @escaping (TRLURLResponse) -> Void
        ) -> Self
    {
        delegate.queue.addOperation {
            (queue ??  DispatchQueue.main).async {
                let resp = TRLURLResponse.init(
                    request: (self.request as URLRequest?),
                    response: self.response,
                    data: (self.delegate.data?.copy() as? Data),
                    error: self.delegate.error
                )
                block(resp)
            }
        }

        return self
    }
}

extension TRLURLDataRequest { 

    @discardableResult
    @objc(responseJSON:)
    public func responseJSON(block: @escaping (JSON?, Error?) -> Void) -> Self {
        return self.responseJSON(withQueue: nil, block: block)
    }

    @discardableResult
    @objc(responseJSONWithQueue:block:)
    public func responseJSON(withQueue queue: DispatchQueue?, block: @escaping (JSON?, Error?) -> Void) -> Self {
        return self.response(withQueue: queue) { (data, error) in
            if let error = error {
                block(nil, error)
            } else {
                do {
                    let json: JSON = try JSON(data: data!)
                    block(json, nil)
                } catch {
                    block(nil, error)
                }
            }
        }
    }

}
