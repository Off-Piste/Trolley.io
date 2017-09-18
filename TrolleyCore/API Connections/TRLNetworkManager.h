//
//  TRLNetworkManager.h
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

@class TRLNetwork;
@protocol TRLURLParameterEncoding;
@class TRLRequest;
@class Reachability;

#import "TNTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRLNetworkManager : NSObject {
    TRLNetwork *_network;
}

UNAVAILABLE_INIT;

@property (strong, readonly) Reachability *reachability;

/**
 The WebSocket URL
 */
@property (strong, readonly) NSURL *connectionURL;

/**
 Method to GET a url with the a path.

 This method uses the base url and adds a path comment
 to that url so we never mutate the base URL.

 Called like so:

 @code
 // i.e network = "http://api_url.io/API"
 TRLRequest *req = [network get:@"products"];
 // req URL = "http://api_url.io/API/products"
 @endcode

 @note By default this passes an empty Parameters dictionary, as
 the end user may wish to add things later on that they didn't
 know they could do before.

 @param path The path you wish to append
 @return A TRLRequest instance.
 */
- (TRLRequest *)get:(NSString *)path;

/**
 Method to GET a url with the a path and Parameters.

 This method uses the base url and adds a path comment
 to that url so we never mutate the base URL.

 Called like so:

 @code
 // i.e network = "http://api_url.io/API"
 TRLRequest *req = [network get:@"products" parameters:{@"foo":@"bar"}];
 // req URL = "http://api_url.io/API/products?foo=bar"
 @endcode

 @note By default this passes the parameters use
 @c[TRLURLEncoding defaultEncoding]

 @param path        The path you wish to append
 @param parameters  The Parmeters for the URL Request, can be set to NULL.
                    if thats the case please use @c-[get:]
 @return            A TRLRequest instance.
 */
- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *_Nullable)parameters;

/**
 Method to GET a url with the a path, parameters and the encoding for said
 parmeters.

 This method uses the base url and adds a path comment
 to that url so we never mutate the base URL.

 Called like so:

 @code
 // i.e network = "http://api_url.io/API"
 TRLRequest *req = [network get:@"products" 
                     parameters:{@"foo":@"bar"} 
                       encoding:[TRLURLEncoding defaultEncoding]];
 // req URL = "http://api_url.io/API/products?foo=bar"
 @endcode

 @note By default this passes the HTTPHeaders as NULL. Accept-Encoding,
 Accept-Language and User-Agent are included in the request

 @param path        The path you wish to append
 @param parameters  The Parmeters for the URL Request, can be set to NULL.
                    if thats the case please use @c-[get:]
 @param encoding    A TRLURLParameterEncoding conforming class
 @return            A TRLRequest instance.
 */
- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *_Nullable)parameters
           encoding:(id<TRLURLParameterEncoding>)encoding;

/**
 Method to GET a url with the a path, parameters, the encoding for said
 parmeters and the HTTPHeaders.

 This method uses the base url and adds a path comment
 to that url so we never mutate the base URL.

 Called like so:

 @code
 // i.e network = "http://api_url.io/API"
 TRLRequest *req = [network get:@"products"
                     parameters:@{@"foo":@"bar"}
                       encoding:[TRLURLEncoding defaultEncoding]
                        headers:@{@"From": @"user@example.com"}];
 // req URL = "http://api_url.io/API/products?foo=bar"
 @endcode

 @note By default Accept-Encoding, Accept-Language and User-Agent 
 are included in the request

 @param path        The path you wish to append
 @param parameters  The Parmeters for the URL Request, can be set to NULL.
 @param encoding    A TRLURLParameterEncoding conforming class
 @param headers     The HTTPHeaders for the request
 @return            A TRLRequest instance.
 */
- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *_Nullable)parameters
           encoding:(id<TRLURLParameterEncoding>)encoding
            headers:(HTTPHeaders *_Nullable)headers;

@end

NS_ASSUME_NONNULL_END
