//
//  TRLURLSessionManager.m
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

#import "TRLURLSessionManager.h"
//#import "TRLURLSessionManager_Requests.h"

#import "TRLURLParameterEncoding.h"
#import "TRLURLEncoding.h"
#import "NSMutableURLRequest+Reqestable.h"
#import "TRLURLDataRequest.h"

#import <TrolleyCore/TrolleyCore-Swift.h>

TRLURLSessionManager *aManager;

@implementation TRLURLSessionManager

+ (HTTPHeaders *)defaultHTTPHeaders {
    NSString *acceptEncoding = @"gzip;q=1.0, compress;q=0.5";
    NSString *userAgent = [[UserAgent shared] header];
    NSString *acceptLanguage = [NSLocale acceptLanguage];

    return @{@"Accept-Encoding": acceptEncoding, @"Accept-Language": acceptLanguage, @"User-Agent": userAgent };
}

- (dispatch_queue_t)queue {
    return [DispatchQueue random];
}

#pragma mark Lifecycle

+ (TRLURLSessionManager *)defaultManager {
    if (aManager) {
        return aManager;
    }

    @synchronized (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPAdditionalHeaders = [self defaultHTTPHeaders].copy;
        aManager = [TRLURLSessionManager managerForConfiguration:config
                                                        delegate:[[TRLURLSessionDelegate alloc]
                                                                  init]];
        return aManager;
    }
}

+ (instancetype)managerForConfiguration:(NSURLSessionConfiguration *)configuration {
    return [TRLURLSessionManager managerForConfiguration:configuration
                                                delegate:[[TRLURLSessionDelegate alloc] init]];
}

+ (instancetype)managerForConfiguration:(NSURLSessionConfiguration *)configuration
                               delegate:(TRLURLSessionDelegate *)delegate
{
    return [[TRLURLSessionManager alloc] initWithConfiguration:configuration delegate:delegate];
}

+ (instancetype)managerForSession:(NSURLSession *)session
                         delegate:(TRLURLSessionDelegate *)delegate
{
    return [[TRLURLSessionManager alloc] initWithSession:session delegate:delegate];
}

- (instancetype)init {
    return [self initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                              delegate:[[TRLURLSessionDelegate alloc] init]];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
                             delegate:(TRLURLSessionDelegate *)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:delegate
                                                delegateQueue:NULL];

        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSession:(NSURLSession *)session
                       delegate:(TRLURLSessionDelegate *)delegate {
    if (self = [super init]) {
        if (![delegate conformsToProtocol:@protocol(NSURLSessionDelegate)]) {
            return NULL;
        }

        self.delegate = delegate;
        self.session = session;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.delegate.sessionManager = self;
    self.startRequestsImmediately = YES;

    __weak TRLURLSessionManager *weakSelf = self;
    self.delegate.sessionDidFinishEventsForBackgroundURLSession = ^(NSURLSession * session) {
        if (!weakSelf) { return; }
        TRLURLSessionManager *strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf->backgoundCompletion = [[TBackgroundCompletion alloc] init];
        });
    };
}

- (void)dealloc {
    [self.session invalidateAndCancel];
}

#pragma mark DataRequest

- (TRLURLDataRequest *)request:(NSString *)url
                        method:(HTTPMethod)method
                    parameters:(Parameters *)parameters
                      encoding:(id<TRLURLParameterEncoding>)encoding
                       headers:(HTTPHeaders *)headers {
    NSError *error;
    NSMutableURLRequest *orignalRequest = [[NSMutableURLRequest alloc] initWithURL:url
                                                                            method:method
                                                                           headers:headers
                                                                             error:&error];

    if (error) {
        return [self requestForURLRequest:orignalRequest failedWithError:error];
    }

    error = NULL;
    NSURLRequest *encodedRequest = [encoding encode:orignalRequest
                                                      with:parameters
                                                     error:&error].copy;

    if (error) {
        return [self requestForURLRequest:orignalRequest failedWithError:error];
    } else {
        return [self requestForURLRequest:encodedRequest];
    }
}

- (TRLURLDataRequest *)requestForURLRequest:(NSURLRequest *)request {
    TRLURLDataRequestHelper *originalTask = [[TRLURLDataRequestHelper alloc]
                                             initWithUrlRequest:request];

    NSError *error;
    NSURLSessionTask *task = [originalTask taskWithSession:self.session
                                                   request:self.adapter
                                                     queue:self.queue
                                                     error:&error];

    if (error) {
        return [self requestForURLRequest:request failedWithError:error];
    }

    TRLURLRequestTaskTypeData *data = [[TRLURLRequestTaskTypeData alloc]
                                       initWithOriginalTask:originalTask
                                       sessionTask:task];

    TRLURLDataRequest *dataRequest = (TRLURLDataRequest *)[TRLURLDataRequest
                                                           requestForSession:self.session
                                                           requestTask:data
                                                           error:NULL];

    self.delegate[task] = dataRequest;
    if (self.startRequestsImmediately) {
        [dataRequest resume];
    }
    return dataRequest;
}

- (TRLURLDataRequest *)requestForURLRequest:(NSURLRequest *_Nullable)urlRequest
                            failedWithError:(NSError *)error {
    TRLURLRequestTaskTypeData *task = [[TRLURLRequestTaskTypeData alloc]
                                       initWithOriginalTask:NULL
                                       sessionTask:NULL];

    if (urlRequest) {
        TRLURLDataRequestHelper *ogRequest = [[TRLURLDataRequestHelper alloc]
                                              initWithUrlRequest:urlRequest];

        task = [[TRLURLRequestTaskTypeData alloc]
                initWithOriginalTask:ogRequest
                sessionTask:NULL];
    }

    TRLURLDataRequest *request = (TRLURLDataRequest *)[TRLURLDataRequest
                                                       requestForSession:self.session
                                                       requestTask:task
                                                       error:error];
    
    if (self.startRequestsImmediately) { [request resume]; }
    return request;
}

@end
