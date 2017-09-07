/////////////////////////////////////////////////////////////////////////////////
//
//  TRLNetworkInfo.m
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

#import <Foundation/Foundation.h>
#import <TrolleyCore/TRLNetworkInfo.h>
#import <TrolleyCore/TRLNetworkInfo_Internal.h>
#import <TrolleyCore/TrolleyCore-Swift.h>
#import <TrolleyCore/TRLNetworkInfo_Private.h>

@implementation TRLNetworkInfo

- (NSURL *)connectionURL {
    NSString *scheme;

    if (self.secure) {
        scheme = @"wss";
    } else {
        scheme = @"ws";
    }

    NSNumber *port = self.url.port;
    NSString *portString = (port) ? [NSString stringWithFormat:@":%@/", port] : @"/";

    NSString *urlString = [NSString stringWithFormat:@"%@://%@%@.ws?ns=%@",
                           scheme, self.host, portString, self.urlNamespace];
    NSURL *url = [NSURL URLWithString:urlString];

    if (url) {
        return url;
    } else {
        [NSException raise:NSGenericException format:@""];
        return nil;
    }
}

- (instancetype)initWithHost:(NSString *)aHost
                   namespace:(NSString *)aNamespace
                      secure:(BOOL)isSecure
                         url:(NSURL *_Nullable)url {
    self = [super init];
    if (self) {
        self->_url = url;
        self->_host = aHost;
        self->_secure = isSecure;
        self->_urlNamespace = aNamespace;
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url
                                error:(NSError *__autoreleasing *)error {
    return infoForURL(url, error);
}

- (instancetype)addingPath:(NSString *)path error:(NSError * _Nullable __autoreleasing *)error {
    if (self.url) {
        NSURL *aURL = self.url;
        NSString *last = [aURL.absoluteString substringFromIndex:aURL.absoluteString.length - 1];
        NSString *newPath = ([last isEqualToString:@"/"]) ?
        path : [NSString stringWithFormat:@"\%@", path];

        aURL = [aURL URLByAppendingPathComponent:newPath];
        return [[TRLNetworkInfo alloc]
                initWithHost:self.host
                namespace:self.urlNamespace
                secure:self.secure
                url:aURL];
    }

    *error = [TRLError urlIsNil];
    return nil;
}

- (void)addPath:(NSString *)path error:(NSError * _Nullable __autoreleasing *)error {
    if (_url) {
        self.url = [self.url URLByAppendingPathComponent:path];
        return;
    }

    *error = [TRLError urlIsNil];
    return;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        TRLNetworkInfo *rhs = (TRLNetworkInfo *) object;
        return TRLNetworkInfoAreEqual(self, rhs);
    }

    return [super isEqual:object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@{ host=%@, namespace=%@, url=%@, connectionURL=%@}",
            super.description, self.host, self.urlNamespace, self.url, self.connectionURL];
}

@end

BOOL TRLNetworkInfoAreEqual(TRLNetworkInfo *lhs, TRLNetworkInfo *rhs) {
    return [lhs.url isEqual:rhs.url] &&
    [lhs.host isEqualToString:rhs.host] &&
    [lhs.urlNamespace isEqualToString:rhs.urlNamespace] &&
    [lhs.connectionURL isEqual:rhs.connectionURL];
}

TRLNetworkInfo *_Nullable infoForURL(NSString *url, NSError *__autoreleasing *error) {
    NSURLComponents *comps = [[NSURLComponents alloc] initWithString:url];
    if (comps) {
        NSURL *aURL = [NSURL URLWithString:url];
        if (!aURL) { *error = [TRLError invalidURL:url]; return nil; }

        NSString *host = comps.host;
        NSString *scheme = comps.scheme;

        NSString *namespace;
        BOOL secure;

        NSArray<NSString *> *parts = [host componentsSeparatedByString:@"."];
        if (parts.count == 1 || parts.count == 2 ) {
            NSUInteger colonIndex = [parts[0] rangeOfString:@":"].location;
            if (colonIndex != NSNotFound) {
                secure = ([scheme isEqualToString:@"https"]);
            } else {
                // The sever isn't accectping SSL requests yet
                secure = ([scheme isEqualToString:@"https"]);
            }

            namespace = (parts[0]).lowercaseString;
        } else if (parts.count == 3) {
            NSUInteger colonIndex = [host rangeOfString:@":"].location;
            if (colonIndex != NSNotFound) {
                secure = ([scheme isEqualToString:@"https"]);
            } else {
                // The sever isn't accectping SSL requests yet
                secure = ([scheme isEqualToString:@"https"]);
            }

            if ([parts containsObject:@"api"]) {
                NSUInteger index = [parts indexOfObjectIdenticalTo:@"api"];
                namespace = (parts[index + 1]).lowercaseString;
            } else {
                namespace = (parts[0]).lowercaseString;
            }
        } else if (parts.count == 5) {
            NSUInteger colonIndex = [parts[2] rangeOfString:@":"].location;
            if (colonIndex != NSNotFound) {
                secure = ([scheme isEqualToString:@"https"]);
            } else {
                // The sever isn't accectping SSL requests yet
                secure = YES;
            }

            if ([parts containsObject:@"www"]) {
                NSUInteger index = [parts indexOfObjectIdenticalTo:@"www"];
                namespace = (parts[index + 1]).lowercaseString;
            } else {
                namespace = (parts[0]).lowercaseString;
            }
        } else {
            *error = [TRLError invalidURL:url];
            return nil;
        }

        return [[TRLNetworkInfo alloc] initWithHost:host
                                          namespace:namespace
                                             secure:secure
                                                url:aURL];
    } else {
        *error = [TRLError invalidURL:url];
        return nil;
    }
    
    return [[TRLNetworkInfo alloc] init];
}
