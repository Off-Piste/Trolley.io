//
//  TRLURLRequest.m
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

#import "TRLURLRequest.h"
#import "TRLURLTaskDelegate_Dynamic.h"

#import "TRLURLDataTaskDelegate.h"

#import <TrolleyCore/TrolleyCore-Swift.h>

@interface TRLURLRequest ()

@property (nonatomic, readwrite) TRLURLTaskDelegate *delegate;

@end

@implementation TRLURLRequest

#pragma mark Properties

- (TRLURLTaskDelegate *)delegate {
    [taskDelegateLock lock]; trl_defer { [taskDelegateLock unlock]; };
    return taskDelegate;
}

- (void)setDelegate:(TRLURLTaskDelegate *)delegate {
    [taskDelegateLock lock]; trl_defer { [taskDelegateLock unlock]; };
    taskDelegate = delegate;
}

- (NSURLSessionTask *)task {
    return self.delegate.task;
}

- (NSMutableURLRequest *)request {
    return self.task.originalRequest.mutableCopy;
}

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *) self.task.response;
}

#pragma mark Lifecycle

+ (instancetype)requestForSession:(NSURLSession *)session
                      requestTask:(TRLURLRequestTaskType *)requestTask
                            error:(NSError *)error {
    return [[TRLURLRequest alloc] initWithSession:session requestTask:requestTask error:error];
}

- (instancetype)initWithSession:(NSURLSession *)session
                    requestTask:(TRLURLRequestTaskType *)requestTask
                          error:(NSError *)error {
    if (self = [super init]) {
        self->_session = session;
        self->taskDelegateLock = [[NSLock alloc] init];
        self->_retryCount = 0;
        self->_validations = [[NSMutableArray alloc] init];

        if ([requestTask isKindOfClass:[TRLURLRequestTaskTypeData class]]) {
            self->taskDelegate = [[TRLURLDataTaskDelegate alloc]
                                  initWithTask:requestTask.sessionTask];
            self->originalTask = requestTask.originalTask;
        }

        self.delegate.error = error;
        [self.delegate.queue addOperationWithBlock:^{
            self->endTime = CFAbsoluteTimeGetCurrent();
        }];
    }

    return self;
}

- (instancetype)authenticateForUser:(NSString *)user password:(NSString *)password {
    return [self authenticateForUser:user
                            password:password
                         persistence:NSURLCredentialPersistenceForSession];
}

- (instancetype)authenticateForUser:(NSString *)user password:(NSString *)password persistence:(NSURLCredentialPersistence)persistence {
    NSURLCredential *credential = [NSURLCredential credentialWithUser:user
                                                             password:password
                                                          persistence:persistence];
    return [self authenticateUsingCredential:credential];
}

- (instancetype)authenticateUsingCredential:(NSURLCredential *)credential {
    TRLURLTaskDelegateSetCredential(self.delegate, credential);
    return self;
}

+ (TAuthorizationHeader *)authorizationHeaderForUser:(NSString *)user
                                            password:(NSString *)password
{
    NSData *data = [[NSString stringWithFormat:@"%@:%@", user, password]
                    dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return NULL;
    }

    NSString *credential = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];

    return [[TAuthorizationHeader alloc] initWithKey:@"Authorization"
                                               value:[NSString stringWithFormat:@"Basic %@",
                                                      credential]];
}

- (void)resume {
    if (!self.task) {
        [self.delegate.queue setSuspended:NO];
        return;
    }

    if (startTime == NSNotFound) {
        startTime = CFAbsoluteTimeGetCurrent();
    }

    [self.task resume];
}

- (void)suspend {
    if (!self.task) {
        return;
    }

    [self.task suspend];
}

- (void)cancel {
    if (!self.task) {
        return;
    }

    [self.task cancel];
}

- (NSString *)description {
    NSMutableArray<NSString *> *comp = @[].mutableCopy;

    if (self.request.HTTPMethod) {
        [comp addObject:self.request.HTTPMethod];
    }

    if (self.request.URL.absoluteString) {
        [comp addObject:self.request.URL.absoluteString];
    }

    if (self.response) {
        [comp addObject:[NSString stringWithFormat:@"%lu", self.response.statusCode]];
    }

    return [comp componentsJoinedByString:@" "];
}

@end
