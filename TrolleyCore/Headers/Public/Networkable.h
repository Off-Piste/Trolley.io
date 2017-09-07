//
//  Networkable.h
//  TrolleyCore
//
//  Created by Harry Wright on 30.08.17.
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
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TRLJSON;

typedef void (^handler_void_nsdata_nserror)(NSData *_Nullable data, NSError *_Nullable error) NS_SWIFT_NAME(DataReponse);
typedef void (^handler_void_trljson_nserror)(TRLJSON *_Nullable json, NSError *_Nullable error) NS_SWIFT_NAME(JSONReponse);

@protocol Networkable <NSObject>

- (void)response:(handler_void_nsdata_nserror)callback;
- (void)responseWith:(dispatch_queue_t)queue block:(handler_void_nsdata_nserror)block;
- (void)JSONResponse:(handler_void_trljson_nserror)callback NS_SWIFT_UNAVAILABLE("Please use `responseJSON(block:)` in swift");
- (void)JSONResponseWith:(dispatch_queue_t)queue
                   block:(handler_void_trljson_nserror)callback NS_SWIFT_UNAVAILABLE("Please use `responseJSON(with:block:)` in swift");

@end

NS_ASSUME_NONNULL_END
