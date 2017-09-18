//
//  TRLParsedURL.h
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

@class TRLNetworkInfo;

/**
 The validated URL for the Trolley Network
 */
@interface TRLParsedURL : NSObject

UNAVAILABLE_INIT;

/**
 The Info for the URL
 */
@property (strong, readonly) TRLNetworkInfo *info;

/**
 The URL for network calls
 */
@property (strong, readonly) NSURL *url;

/**
 The WebSocket URL
 */
@property (strong, readonly) NSURL *connectionURL;

/**
 Method to create the ParsedURL.
 
 @warning Will throw and exception if the URL is invalid.

 @param url The URLString for the URL
 @return A valid ParsedURL for our Network
 */
- (instancetype)initWithURLString:(NSString *)url NS_DESIGNATED_INITIALIZER;

/**
 Method to append a path onto the base URL

 @warning USE SPARINGLY!! As will break the URL is messed with

 @param path The path to be added to the URL
 */
- (void)addPath:(NSString *)path;

@end
