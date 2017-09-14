//
//  TRLNetworkManager.m
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

#import "TRLNetworkManager.h"
#import "TRLNetworkManager_Options.h"
#import "TRLNetworkManager_Private.h"

#import "TRLNetwork_Private.h"
#import "TRLParsedURL.h"

#import "TRLURLEncoding.h"

#import "Swift-Fixed-Header.h"

@implementation TRLNetworkManager

- (instancetype)initWithURL:(NSString *)url APIKey:(NSString *)key {
    if (self = [super init]) {
        self->_network = [[TRLNetwork alloc] initWithURLString:url];
        [_network.parsedURL addPath:key];
    }
    return self;
}

- (instancetype)initWithOptions:(TRLOptions *)options {
    return [self initWithURL:options.url APIKey:options.key];
}

- (TRLRequest *)get:(NSString *)path {
    return [self get:path parameters:NULL];
}

- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *)parameters
{
    TRLURLEncoding *encoding = [TRLURLEncoding defaultEncoding];
    return [self get:path parameters:parameters encoding:encoding];
}

- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *)parameters
           encoding:(id<TRLURLParameterEncoding>)encoding
{
    return [self get:path parameters:parameters encoding:encoding headers:NULL];
}

- (TRLRequest *)get:(NSString *)path
         parameters:(Parameters *)parameters
           encoding:(id<TRLURLParameterEncoding>)encoding
            headers:(HTTPHeaders *)headers
{
    return [_network get:path parameters:parameters encoding:encoding headers:headers];
}

- (NSString *)description {
    return _network.description;
}

@end
