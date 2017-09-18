//
//  TRLJSON.m
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

#import "TRLJSON.h"
//#import "TRLJSON+Bridge.h"

#import "TRLMutableJSON.h"
#import "TRLJSONBase_Dynamic.h"

#import "TRLMutableDictionary.h"
#import "TRLMutableArray.h"

#import "NSArray+Map.h"
#import <TrolleyCore/TrolleyCore-Swift.h>

@implementation TRLJSON

+ (instancetype)bridge:(TRLJSONBase *)superclass {
    return [self object:superclass.rawValue];
}

- (id)object {
    return self.rawValue;
}

- (NSUInteger)count {
    switch (self.rawType) {
        case JSONTypeArray: return self->rawArray.count;
        case JSONTypeDictionary: return self->rawDictionary.count;
        default: return 0;
    }
}

+ (instancetype)object:(id)obj {
    if ([obj isKindOfClass:[NSArray<TRLJSON *> class]]) {
        NSArray *array = (NSArray<TRLJSON *>*)obj;
        if (array.isJSON) {
            return [[TRLJSON alloc] initWithArray:(NSArray<TRLJSON *> *)obj];
        }
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        if (dict.isJSON) {
            return [[TRLJSON alloc] initWithDictionary:(NSDictionary<NSString *, TRLJSON *>*)obj];
        }
    }
    return [[TRLJSON alloc] initWithRawValue:obj];
}

+ (instancetype)null {
    return [TRLJSON object:ObjcNull];
}

+ (instancetype)parseJSON:(NSString *)jsonString {
    NSData *d = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (d) {
        return [TRLJSON object:d];
    }
    return [TRLJSON null];
}

- (instancetype)initWithArray:(NSArray<TRLJSON *> *)array {
    return [TRLJSON object:[array map:^id(TRLJSON * obj, NSUInteger idx) {
        return [TRLJSON object:obj.object];
    }]];
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *, TRLJSON *>*)dictionary {
    NSMutableDictionary *newDictionary = @{}.mutableCopy;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, TRLJSON *obj, BOOL *stop) {
        newDictionary[key] = obj.object;
    }];
    return [TRLJSON object:newDictionary];
}

- (id)copyWithZone:(NSZone *)zone {
    TRLJSON *copy = [[[self class] alloc] initWithRawValue:ObjcNull];
    TRLJSONBaseSetRawValue(copy, [self.rawValue copyWithZone:zone]);
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    TRLMutableJSON *copy = [[TRLMutableJSON allocWithZone:zone] initWithRawValue:ObjcNull];
    copy.object = [self.rawValue copyWithZone:zone];
    return copy;
}

- (instancetype)objectForKeyedSubscript:(NSString *)key {
    return [TRLJSON bridge:[super objectForKeyedSubscript:key]];
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    return [TRLJSON bridge:[super objectAtIndexedSubscript:idx]];
}

- (NSArray<TRLJSON *> *)array {
    if (self.rawType == JSONTypeArray) {
        return [self->rawArray map:^id(id obj, NSUInteger idx) {
            return [TRLJSON object:obj];
        }].array;
    }
    return nil;
}

- (NSArray<TRLJSON *> *)arrayValue {
    return self.array ? self.array : @[];
}

- (NSDictionary<NSString *,TRLJSON *> *)dictionary {
    if (self.rawType == JSONTypeDictionary) {
        NSMutableDictionary<NSString *,TRLJSON *> *d = @{}.mutableCopy;
        [self->rawDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [d setValue:[TRLJSON object:obj] forKey:key];
        }];
        return d;
    }
    return nil;
}

- (NSDictionary<NSString *, TRLJSON *> *)dictionaryValue {
    return self.dictionary ? self.dictionary : @{};
}

- (NSNumber *)number {
    switch (self.rawType) {
        case JSONTypeNumber: return self->rawNumber;
        case JSONTypeBool: return @(self->rawBool);
        case JSONTypeString: {
            NSNumber *n = [[NSNumber alloc] initWithString:self->rawString];
            if (n) {
                return n;
            }
            return nil;
        }
        default: return nil;
    }
}

- (NSNumber *)numberValue {
    return self.number ? self.number : 0;
}

- (NSString *)string {
    switch (self.rawType) {
        case JSONTypeString: return self->rawString;
        case JSONTypeNumber: return self->rawNumber.stringValue;
        case JSONTypeBool: return self->rawBool ? @"true" : @"false";
        default: return nil;
    }
}

- (NSString *)stringValue {
    return self.string ? self.string : @"";
}

@end
