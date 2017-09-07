/////////////////////////////////////////////////////////////////////////////////
//
//  TRLURLRequest.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
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
#import "TRLURLRequest_Internal.h"
#import "TRLURLRequestBuilder.h"
#import "TRLURLEncoding.h"
#import "TRLURLRequest_Response.h"
#import <TrolleyCore/TrolleyCore-Swift.h>
#import "TRLLogger.h"
#import "NSMutableString+URLFormatter.h"

//@import PromiseKit;

@implementation TRLURLRequest

- (NSURLRequest *)request {
    return _originalRequest;
}

- (NSError *)error {
    return _error;
}

- (dispatch_queue_t)queue {
    NSString *fmt = @"io.trolley.core.networking.%@";
    NSString *uuid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@"."].lowercaseString;
    NSString *label = [NSString stringWithFormat:fmt, uuid];
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
}

- (NSURLSession *)session {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = [TRLURLRequestBuilder defaultHTTPHeaders];
    return [NSURLSession sessionWithConfiguration:configuration];
}

# pragma mark Inits

- (instancetype)initWithRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        self->_originalRequest = request;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request failedForError:(NSError *)error {
    self = [super init];
    if (self) {
        self->_error = error;
        self->_originalRequest = request;
    }
    return self;
}

#pragma mark NSObject Overrides

- (NSString *)description {
    return (_originalRequest) ? _originalRequest.URL.absoluteString : _error.localizedDescription;
}

- (NSString *)debugDescription {
     return (_originalRequest) ? [self cURLCommandFromURLRequest:_originalRequest] : _error.localizedDescription;
}

/// This is taken from FormatterKit
/// https://github.com/mattt/FormatterKit/blob/master/FormatterKit/TTTURLRequestFormatter.m
- (NSString *)cURLCommandFromURLRequest:(NSURLRequest *)request {
    NSMutableString *command = [NSMutableString stringWithString:@"curl"];

    [command appendCommandLineArgument:[NSString stringWithFormat:@"-X %@", [request HTTPMethod]]];

    if ([[request HTTPBody] length] > 0) {
        NSMutableString *HTTPBodyString = [[NSMutableString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
        [HTTPBodyString replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0, [HTTPBodyString length])];
        [HTTPBodyString replaceOccurrencesOfString:@"`" withString:@"\\`" options:0 range:NSMakeRange(0, [HTTPBodyString length])];
        [HTTPBodyString replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [HTTPBodyString length])];
        [HTTPBodyString replaceOccurrencesOfString:@"$" withString:@"\\$" options:0 range:NSMakeRange(0, [HTTPBodyString length])];
        [command appendCommandLineArgument:[NSString stringWithFormat:@"-d \"%@\"", HTTPBodyString]];
    }

    NSString *acceptEncodingHeader = [[request allHTTPHeaderFields] valueForKey:@"Accept-Encoding"];
    if ([acceptEncodingHeader rangeOfString:@"gzip"].location != NSNotFound) {
        [command appendCommandLineArgument:@"--compressed"];
    }

    if ([request URL]) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[request URL]];
        if (cookies.count) {
            NSMutableString *mutableCookieString = [NSMutableString string];
            for (NSHTTPCookie *cookie in cookies) {
                [mutableCookieString appendFormat:@"%@=%@;", cookie.name, cookie.value];
            }

            [command appendCommandLineArgument:[NSString stringWithFormat:@"--cookie \"%@\"", mutableCookieString]];
        }
    }

    for (id field in [request allHTTPHeaderFields]) {
        [command appendCommandLineArgument:[NSString stringWithFormat:@"-H %@", [NSString stringWithFormat:@"'%@: %@'", field, [[request valueForHTTPHeaderField:field] stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"]]]];
    }

    [command appendCommandLineArgument:[NSString stringWithFormat:@"\"%@\"", [[request URL] absoluteString]]];

    return [NSString stringWithString:command];
}

#pragma mark Response

- (void)response:(handler_void_nsdata_nserror)callback {
    [self responseWith:self.queue block:callback];
    return;
}

- (void)responseWith:(dispatch_queue_t)queue block:(handler_void_nsdata_nserror)block {
    if (self.error) {
        block(NULL, self.error);
        return;
    }

    NSLog(@"%@ %@", queue.description, self.session.description);

    // Why use promise kit?
    // Well it helps keep all my internal aysnc code neat and is easly readable
    // for all who wish to use us, and it pre-validates the JSON so saves us
    // adding a new couple methods to ask users if they wish to validate like
    // alamofire does.
//    [self.session promiseDataTaskWithRequest:self.request]
//    .thenOn(queue, ^(id obj){
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            TRLJSON *json = [[TRLJSON alloc] init:obj];
//            if (json.error) {
//                @throw json.error; // Highly unlikly but do so anyway
//            }
//            block(json.rawData, NULL);
//        } else if ([obj isKindOfClass:[NSString class]]) {
//            NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
//            if (data) {
//                block(data, NULL);
//            } else {
//                // Highly unlikly but do so anyway
//                @throw [TRLError invalidJSON:(NSString *)obj];
//            }
//        } else {
//            block((NSData *)obj, NULL);
//        }
//    }).catch(^(NSError *error){
//        block(NULL, error);
//    });

    return;

}

                    /**********************************************************
                     *      Not a huge fan of these method names              *
                     *      will have to see what i can do about              *
                     *      it as i know from before i can't have             *
                     *      them as - [responseJSON:] bc if i extend          *
                     *      the code is swift and add a reponseJSON()         *
                     *      method with SwiftJSON it throughs a wobbler.      *
                     *                                                        *
                     *      So could go with <Object>Response for Objc        *
                     *      and response<Object> for Swift but that could     *
                     *      become annoying for users, or create a Request    *
                     *      struct and add the Swift methods inside like      *
                     *      how swift stdlib is done.                         *
                     *                                                        *
                     *      - Update: Deciced with <Object>Response for Objc  *
                     *      and response<Object> for Swift and make them      *
                     *      `NS_SWIFT_UNAVAILABLE` and @nonobjc alike         *
                     **********************************************************/

- (void)JSONResponse:(handler_void_trljson_nserror)callback {
    [self JSONResponseWith:self.queue block:callback];
}

- (void)JSONResponseWith:(dispatch_queue_t)queue block:(handler_void_trljson_nserror)callback {
    [self responseWith:queue block:^(NSData *data, NSError *error) {
        if (error) {
            callback(NULL, error);
        } else {
            NSError *error;
            TRLJSON *json = [[TRLJSON alloc] initWithNullable_data:data error:&error];
            if (error) {
                callback(NULL, error);
            } else if (json.error) {
                callback(NULL, json.error);
            } else {
                callback(json, NULL);
            }
        }
    }];
}

#pragma mark Requests

+ (TRLURLRequest *)request:(NSString *)url {
    return [self request:url method:@"GET"];
}

+ (TRLURLRequest *)request:(NSString *)url method:(HTTPMethod *)method {
    return [self request:url method:method parameters:nil];
}

+ (TRLURLRequest *)request:(NSString *)url parameters:(Parameters *)parameters {
    return [self request:url method:@"GET" parameters:parameters];
}

+ (TRLURLRequest *)request:(NSString *)url method:(HTTPMethod *)method parameters:(Parameters *)parameters {
    TRLURLEncoding *encoding = [TRLURLEncoding defaultEncoding];
    return [self request:url method:method parameters:parameters encoding:encoding];
}

+ (TRLURLRequest *)request:(NSString *)url method:(HTTPMethod *)method parameters:(Parameters *)parameters encoding:(id<TRLURLParameterEncoding>)encoding {
    return [self request:url method:method parameters:parameters encoding:encoding header:nil];
}

+ (TRLURLRequest *)request:(NSString *)url method:(HTTPMethod *)method parameters:(Parameters *)parameters encoding:(id<TRLURLParameterEncoding>)encoding header:(HTTPHeaders *)headers {
    return [[TRLURLRequestBuilder defaultRequestBuilder] requestWithURL:url method:method parameters:parameters encoding:encoding headers:headers];
}

@end
