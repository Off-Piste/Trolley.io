//
//  TRLURLSessionManager.h
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 09.09.17.
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

#import "TNTUtils.h"

@class TRLURLSessionDelegate;
@class TBackgroundCompletion;
@class TRLURLDataRequest;

@protocol RequestAdapter;
@protocol TRLURLParameterEncoding;

NS_ASSUME_NONNULL_BEGIN

@interface TRLURLSessionManager : NSObject {
    TBackgroundCompletion *_Nullable backgoundCompletion;
}

#pragma mark Lifecycle

+ (instancetype)managerForSession:(NSURLSession *)session
                                   delegate:(TRLURLSessionDelegate *)delegate;

+ (instancetype)managerForConfiguration:(NSURLSessionConfiguration *)configuration;

+ (instancetype)managerForConfiguration:(NSURLSessionConfiguration *)configuration
                               delegate:(TRLURLSessionDelegate *)delegate;

#pragma mark Properties

@property (strong, nonatomic) dispatch_queue_t queue;

@property (strong, nonatomic) NSURLSession *session;

@property (strong, nonatomic) TRLURLSessionDelegate *delegate;

@property (assign, nonatomic) BOOL startRequestsImmediately;

@property (strong, nonatomic) id<RequestAdapter> adapter;

@property (class, readonly) TRLURLSessionManager *defaultManager NS_SWIFT_NAME(default);

+ (HTTPHeaders *)defaultHTTPHeaders;

#pragma mark Requests

- (TRLURLDataRequest *)request:(NSString *)url
                        method:(HTTPMethod)method
                    parameters:(Parameters *_Nullable)parameters
                      encoding:(id<TRLURLParameterEncoding>)encoding
                       headers:(HTTPHeaders *_Nullable)headers;

- (TRLURLDataRequest *)requestForURLRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
