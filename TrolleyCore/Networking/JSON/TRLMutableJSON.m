//
//  TRLMutableJSON.m
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 05.09.17.
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

#import "TRLMutableJSON.h"
//#import "TRLMutableJSON_Private.h"

#import "TRLJSONBase_Dynamic.h"

@implementation TRLMutableJSON

#pragma mark properties

@synthesize object = mutableObject;

- (id)object {
    return self.rawValue;
}

- (void)setObject:(id)object {
    TRLJSONBaseSetRawValue(self, object);
}

# pragma mark - Subscript
//
//- (void)setObject:(TRLMutableJSON *)obj forKeyedSubscript:(NSString *)key {
//    TRLJSONBaseSetObjectForKeyedSubscript(self, key, obj);
//}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    if (!obj) {
        return;
    }

    if ([obj isKindOfClass:[TRLJSONBase class]]) {
        TRLJSONBaseSetObjectForKeyedSubscript(self, key, (TRLJSONBase *)obj);
    } else {
        JSONBase(object, obj)
        TRLJSONBaseSetObjectForKeyedSubscript(self, key, object);
        
    }
}

- (instancetype)objectForKeyedSubscript:(NSString *)key {
    return [TRLMutableJSON bridge:[super objectForKeyedSubscript:key]];
}

//- (void)setObject:(TRLMutableJSON *)obj atIndexedSubscript:(NSUInteger)idx {
//    TRLJSONBaseSetObjectForIndexedSubscript(self, idx, obj);
//}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (!obj) {
        return;
    }

    if ([obj isKindOfClass:[TRLJSONBase class]]) {
        TRLJSONBaseSetObjectForIndexedSubscript(self, idx, (TRLJSONBase *)obj);
    } else {
        JSONBase(base, obj)
        TRLJSONBaseSetObjectForIndexedSubscript(self, idx, base);
    }
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    return [TRLMutableJSON bridge:[super objectAtIndexedSubscript:idx]];
}

# pragma mark - <NSCopying, NSMutableCopying>

- (id)copyWithZone:(NSZone *)zone {
    TRLJSON *copy = [TRLJSON object:self.object];
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    TRLMutableJSON *copy = [super mutableCopyWithZone:zone];
    copy->mutableObject = [mutableObject mutableCopyWithZone:zone];
    return copy;
}

+ (instancetype)bridge:(TRLJSON *)superclass {
    return [self object:superclass.rawValue];
}

@end
