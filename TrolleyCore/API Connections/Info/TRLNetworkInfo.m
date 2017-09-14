//
//  TRLNetworkInfo.m
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

#import "TRLNetworkInfo.h"
#import "TRLNetworkInfo_Private.h"

#import "TRLError.h"

@implementation TRLNetworkInfo {
    NSURL *_internalURL;
}

- (NSURL *)url {
    return self->_internalURL;
}

- (BOOL)isDemoHost {
    return [self.host isEqualToString:@"localhost"];
}

+ (instancetype)networkInfoForURL:(NSString *)url error:(NSError *__autoreleasing *)error {
    return infoForURL(url, error);
}

- (instancetype)initWithHost:(NSString *)host
                   namespace:(NSString *)namespace
                      secure:(BOOL)isSecure
                         url:(NSURL *)url {
    self = [super init];
    if (self) {
        self->_host = host;
        self->_urlNamespace = namespace;
        self->_secure = isSecure;
        self->_internalURL = url;
    }
    return self;
}

- (void)addPath:(NSString *)path {
    NSLog(@"Please be aware that adding a path to the URL can be fatal, make sure it is necessary");
    self->_internalURL = [self->_internalURL URLByAppendingPathComponent:path];
}

#pragma mark - NSObject Overrides

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return TRLNetworkInfoAreEqual(self, (TRLNetworkInfo *)other);
    } else {
        return [super isEqual:other];
    }
}

- (NSUInteger)hash {
    return self.url.hash;
}

- (NSString *)description {
    return self.url.absoluteString;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@{host=%@, namespace=%@, url=%@, connectionURL=%@}",
            super.description, self.host, self.urlNamespace, self.url, self.connectionURL];
}

@end

#pragma mark - Helper Code

static BOOL TRLNetworkInfoAreEqual(TRLNetworkInfo *lhs, TRLNetworkInfo *rhs) {
    return [lhs.url isEqual:rhs.url] &&
    [lhs.host isEqualToString:rhs.host] &&
    [lhs.urlNamespace isEqualToString:rhs.urlNamespace] &&
    [lhs.connectionURL isEqual:rhs.connectionURL];
}

static TRLNetworkInfo *_Nullable infoForURL(NSString *url, NSError *__autoreleasing *error) {
    NSURLComponents *comps = [[NSURLComponents alloc] initWithString:url];
    if (comps) {
        // Assume the URL is valid as comps is not null
        NSURL *aURL = comps.URL;

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
            *error = TRLMakeError(TRLErrorInvalidURL, @"URL: %@ has too many or too little parts", url);
            return nil;
        }

        return [[TRLNetworkInfo alloc] initWithHost:host
                                          namespace:namespace
                                             secure:secure
                                                url:aURL];
    } else {
        *error = TRLMakeError(TRLErrorInvalidURL, @"Invalid URL: %@", url);;
        return nil;
    }
}
