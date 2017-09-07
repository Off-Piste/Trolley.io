/////////////////////////////////////////////////////////////////////////////////
//
//  TRLRequest.h
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
//

#import <Foundation/Foundation.h>
#import "Networkable.h"

@class TRLURLRequest;

NS_ASSUME_NONNULL_BEGIN

/**
 Comming Soon.
 */
typedef void (^handler_void_progress)(NSProgress *progress) NS_SWIFT_NAME(Progress);

/**
 Class that allows all API traffic to be created. 

 @warning Internal class. Please do not use directly.
 */
@interface TRLRequest : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 The request for the call, may move this internally.
 */
@property (nonatomic, readonly) TRLURLRequest *request;

/**
 Method to be called once finishing a request.
 
 This methods checks the URL and its parameters to
 make sure they are valid for the end-point, does not
 check if a valid URL as this is done by TRLURLRequest.

 @warning Will raise an exception for invalid calls

 @return a TRLURLRequest for the call.
 */
- (id<Networkable>)validate;

/**
 Comming Soon.
 */
- (id<Networkable>)progressOn:(dispatch_queue_t)queue block:(handler_void_progress)block NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
