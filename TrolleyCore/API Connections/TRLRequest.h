//
//  TRLRequest.h
//  TRLNetwork
//
//  Created by Harry Wright on 13.09.17.
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

@class TRLURLDataRequest;

@protocol TRLURLParameterEncoding;

NS_ASSUME_NONNULL_BEGIN

/**
 TRLRequest is the end point for our Request
 
 Only thing that can be mutated here is the Parameters
 they can be added and removed based on the Trolley request that
 is been created.
 
 Please use like follows inside the internal code:
 
 @code
    TRLURLDataRequest *req = [trlRequest request];
    [req response:^(NSData *data, NSError *error) {
        ...
    }];
 @endcode
 
 @warning Please don't write to HTTPMethod, ran into an initalisation error so is not readonly
 */
@interface TRLRequest : NSObject

UNAVAILABLE_INIT;

/**
 The underlying TRLURLDataRequest of the TRLRequest
 
 @see TRLURLDataRequest
 */
@property (strong, nonnull, readonly) TRLURLDataRequest *request;

/**
 The NSString/String representation of the URL
 */
@property (strong, nonnull, readonly) NSString *url;

/**
 The method for the HTTP request.
 
 @note For swift please just call `.GET` or `.POST`
 */
@property (assign, nonnull) HTTPMethod method;

/**
 The parameters for the URL, how this is added to the request if defined inside
 encoding.
 
 So if you need a custom encoding just add a new class that subclasses `TRLURLParameterEncoding`
 and pass that in the encoding and it will work your way.
 */
@property (strong, nonnull, readonly) Parameters *parameters;

/**
 The TRLURLParameterEncoding for the URL
 */
@property (strong, nonnull, readonly) id<TRLURLParameterEncoding> encoding;

/**
 The Headers for the URLRequest
 
 @note Accept-Encoding, Accept-Language, User-Agent are added by default
 */
@property (strong, nonnull, readonly) HTTPHeaders *headers;

/**
 Initaliser for the Request, this should never be public, only to be created via 
 TRLNetworkManager or a sepcific Trolley subspec.
 
 @warning This is for internal use, please do not use.

 @param url         The NSString/String representation of the URL
 @param method      The method for the HTTP request.
 @param parameters  The parameters for the URL
 @param encoding    The TRLURLParameterEncoding for the URL
 @param headers     The Headers for the URLRequest
 @return            A TRLRequest Instance.
 */
- (instancetype)initWithURL:(NSString *)url
                     method:(HTTPMethod)method
                 parameters:(Parameters *)parameters
                   encoding:(id<TRLURLParameterEncoding>)encoding
                    headers:(HTTPHeaders *)headers NS_DESIGNATED_INITIALIZER;


@end

NS_ASSUME_NONNULL_END
