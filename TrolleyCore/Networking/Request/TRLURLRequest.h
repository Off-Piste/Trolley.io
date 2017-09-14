//
//  TRLURLRequest.h
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
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>

@class TAuthorizationHeader;
@class TRLURLTaskDelegate;
@class TRLURLRequestTaskType;
@class TValidationsIndex;
@protocol TRLTaskConvertible;

#import "TNTUtils.h"
#import "TRLBlocks.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRLURLRequest : NSObject {
    TRLURLTaskDelegate *taskDelegate;
    NSLock *taskDelegateLock;
    CFAbsoluteTime startTime;
    CFAbsoluteTime endTime;
    id<TRLTaskConvertible> originalTask;
}

@property (nonatomic, readonly) TRLURLTaskDelegate *delegate;

@property (nonatomic, strong) NSMutableArray<TValidationsIndex *>* validations;

@property (nonatomic, readonly, nullable) NSURLSessionTask *task;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, readonly, nullable) NSMutableURLRequest *request;

@property (nonatomic, readonly, nullable) NSHTTPURLResponse *response;

@property (nonatomic, readwrite) NSUInteger retryCount;

+ (instancetype)requestForSession:(NSURLSession *)session
                      requestTask:(TRLURLRequestTaskType *)requestTask
                            error:(NSError *_Nullable)error;

- (instancetype)authenticateForUser:(NSString *)user
                           password:(NSString *)password
NS_SWIFT_NAME(authenticate(user:password:));

- (instancetype)authenticateForUser:(NSString *)user
                           password:(NSString *)password
                        persistence:(NSURLCredentialPersistence)persistence
NS_SWIFT_NAME(authenticate(user:password:persistence:));

- (instancetype)authenticateUsingCredential:(NSURLCredential *)credential;

+ (TAuthorizationHeader *_Nullable)authorizationHeaderForUser:(NSString *)user
                                                     password:(NSString *)password
NS_SWIFT_NAME(authorizationHeaderForUser(_:password:));

- (void)resume;

- (void)suspend;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
