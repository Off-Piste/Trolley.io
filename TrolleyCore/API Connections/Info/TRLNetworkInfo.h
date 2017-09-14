//
//  TRLNetworkInfo.h
//  RequestBuilder
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

#import "TNTUtils.h"

NS_ASSUME_NONNULL_BEGIN

/**
 TRLNetworkInfo is the class that holds all the Network Info for our API
 Network and is used to create our WebSocket URL
 */
@interface TRLNetworkInfo : NSObject

UNAVAILABLE_INIT;

/**
 The URL Host
 */
@property (strong, readonly) NSString *host;

/**
 The URL namespace
 */
@property (strong, readonly) NSString *urlNamespace;

/**
 Bool for if the URL is secure
 */
@property (readonly) BOOL secure;

/**
 The URL for network calls
 */
@property (strong, readonly) NSURL *url;

/**
 The WebSocket URL
 */
@property (strong, readonly) NSURL *connectionURL;

/**
 Method to check if the URL is a demo URL
 
 @warning Change when finishes as should check for default api key

 @return Bool test for if the URL is a demo URL
 */
- (BOOL)isDemoHost;

/**
 Method to create a TRLNetworkInfo from a NSString and pass back an error

 @param url NSString of the URL you wish to use
 @param error If an internal error occurs, upon return contains an NSError
 @return TRLNetworkInfo for the URL, or nil if an internal error occurs.
 */
+ (nullable instancetype)networkInfoForURL:(NSString *)url error:(NSError *__autoreleasing *)error;

/**
 Method to append a path onto the base URL
 
 @warning USE SPARINGLY!! As will break the URL is messed with

 @param path The path to be added to the URL
 */
- (void)addPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
