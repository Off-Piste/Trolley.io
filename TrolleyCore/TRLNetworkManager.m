/////////////////////////////////////////////////////////////////////////////////
//
//  TRLNetworkManager.m
//  TrolleyCore
//
//  Created by Harry Wright on 25.08.17.
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
#import "TRLNetworkManager_Internal.h"
#import "TRLNetwork.h"
#import "ParsedURL_Internal.h"
#import "NSString+URL.h"

@implementation TRLNetworkManager {
    TRLNetwork *_network;
}

+ (TRLNetworkManager *)shared {
    return [TRLNetworkManager new];
}

#pragma mark properties

- (NSURL *)url {
    if (_network.url) {
        return _network.url;
    }

    [NSException raise:NSGenericException
                format:@"A valid URL is required for networking calls to our API"];
    return nil;
}

- (NSURL *)connectionURL {
    if (_network.connectionURL) {
        return _network.connectionURL;
    }

    [NSException raise:NSGenericException
                format:@"A valid URL is required for connection to our websocket"];
    return nil;
}

#pragma mark - init

- (instancetype)initWithNetwork:(TRLNetwork *)network key:(NSString *)key {
    self = [super init];
    if (self) {
        self->_network = network;
        [_network._url addPath:key];
    }

    return self;
}

- (instancetype)initWithURL:(NSString *)url key:(NSString *)key {
    NSError *error;
    TRLNetwork *network = [[TRLNetwork alloc] initWithURL:url error:&error];

    if (error) {
        [NSException raise:NSGenericException format:@"%@", error.localizedDescription];
        return nil;
    }

    return [[TRLNetworkManager alloc] initWithNetwork:network key:key];
}

#pragma mark - routing

- (TRLRequest *)get:(NSString *)route
       with:(Parameters *)parameters
   encoding:(id<TRLURLParameterEncoding>)encoding
    headers:(HTTPHeaders *)headers {
    return [_network get:route with:parameters encoding:encoding headers:headers];
}

- (TRLRequest *)getItems:(NSArray<NSString *> *)items
            with:(Parameters *)parameters
        encoding:(id<TRLURLParameterEncoding>)encoding
         headers:(HTTPHeaders *)headers {
    return [self get:[NSString stringURLRouteFor:items] with:parameters encoding:encoding headers:headers];
}

@end
