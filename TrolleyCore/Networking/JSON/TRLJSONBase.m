//
//  TRLJSONBase.m
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

#import "TRLJSONBase.h"
#import "TRLJSONBase_Dynamic.h"
#import "TRLJSONBase_Private.h"

#import "TRLMutableDictionary.h"
#import "TRLMutableArray.h"

#import "TRLError.h"
#import <TrolleyCore/TrolleyCore-Swift.h>

@implementation TRLJSONBase

- (id)rawValue {
    switch (self.rawType) {
        case JSONTypeDictionary: return self->rawDictionary.dictionary;
        case JSONTypeArray: return self->rawArray.array;
        case JSONTypeString: return self->rawString;
        case JSONTypeNumber: return self->rawNumber;
        case JSONTypeBool: return @(self->rawBool);
        default: return self->rawNull;
    }
}

- (JSONType)rawType {
    return self->_rawType;
}

- (NSError *)error {
    return self->_error;
}

- (instancetype)initWithRawValue:(id)value {
    if ([value isKindOfClass:[NSData class]]) {
        return [self initWithData:(NSData *)value];
    }
    return [self init:value];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data options:NSJSONReadingAllowFragments];
}

- (instancetype)initWithData:(NSData *)data options:(NSJSONReadingOptions)opt {
    return [self initWithData:data options:opt error:NULL];
}

- (instancetype)initWithData:(NSData *)data
                     options:(NSJSONReadingOptions)opt
                       error:(NSError *__autoreleasing  _Nullable *)error {
    NSError *aError;
    id object = [NSJSONSerialization JSONObjectWithData:data options:opt error:&aError];

    if (aError && aError) {
        *error = aError;
        return [self initWithRawValue:[NSNull null]];
    }

    return [self initWithRawValue:object];
}


- (instancetype)init:(id)obj {
    self = [super init];
    if (self) {
        [self initalise];
        TRLJSONBaseSetRawValue(self, obj);
    }
    return self;
}

- (instancetype)objectForKeyedSubscript:(NSString *)key {
    TRLJSONBase *r;
    if (self->_rawType == JSONTypeDictionary) {
        id obj = self->rawDictionary[key];

        if (obj) {
            r = [[TRLJSONBase alloc] initWithRawValue:obj];
        } else {
            r = [[TRLJSONBase alloc] initWithRawValue:[NSNull null]];
            r->_error = TRLMakeError(TRLErrorJSONWrongType, @"Dictionary[%@] does not exist", key);
        }
    } else {
        r = [[TRLJSONBase alloc] initWithRawValue:[NSNull null]];
        r->_error = self->_error ? self->_error : TRLMakeError(TRLErrorJSONWrongType, @"Dictionary[%@], failure, it is not an dictionary", key);
    }
    return r;
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    TRLJSONBase *r;
    if (self->_rawType == JSONTypeArray) {
        id obj = self->rawArray[idx];

        if (obj) {
            r = [[TRLJSONBase alloc] initWithRawValue:obj];
        } else {
            r = [[TRLJSONBase alloc] initWithRawValue:[NSNull null]];
            r->_error = TRLMakeError(TRLErrorJSONWrongType, @"Array[%lu] does not exist", (unsigned long)idx);
        }
    } else {
        r = [[TRLJSONBase alloc] initWithRawValue:[NSNull null]];
        r->_error = self->_error ? self->_error : TRLMakeError(TRLErrorJSONWrongType, @"Array[%lu], failure, it is not an dictionary", (unsigned long)idx);
    }
    return r;
}

- (NSData *)rawDataWithError:(NSError * _Nullable __autoreleasing *)error {
    return [self rawDataWithOptions:0 error:error];
}

- (NSData *)rawDataWithOptions:(NSJSONWritingOptions)opt error:(NSError * _Nullable __autoreleasing *)error {
    if (![NSJSONSerialization isValidJSONObject:self.rawValue]) {
        *error = TRLMakeError(TRLErrorJSONInvalidJSON, @"JSON is invalid");
        return nil;
    }
    return [NSJSONSerialization dataWithJSONObject:self.rawValue options:opt error:error];
}

- (NSString *)rawString {
    return [self rawString:NSUTF8StringEncoding];
}

- (NSString *)rawString:(NSStringEncoding)encoding {
    return [self rawString:encoding options:NSJSONWritingPrettyPrinted];
}

- (NSString *)rawString:(NSStringEncoding)encoding options:(NSJSONWritingOptions)opt {
    NSError *error;
    WrittingOptions *options = [[WrittingOptions alloc] initWithKey:KeyJsonSerialization value:@(opt)];

    NSString *str = RawJSONStringForTRLJSONBase(self, encoding, @[options], 10, &error);
    if (error) {
        NSLog(@"Could not serialize object to JSON because: %@", error.localizedDescription);
    }

    return str;
}

- (void)initalise {
    self->rawArray = [[TRLMutableArray alloc] init];
    self->rawDictionary = [[TRLMutableDictionary alloc] init];
    self->rawString = @"";
    self->rawNumber = 0;
    self->rawNull = [NSNull null];
    self->rawBool = NO;
    self->_rawType = JSONTypeUnknown;
}

- (BOOL)isEqual:(id)object {
    if ([[object class] isSubclassOfClass:[TRLJSONBase class]]) {
        return TRLJSONBaseIsEqual(self, (TRLJSONBase *)object);
    }
    return [super isEqual:object];
}

- (NSString *)description {
    NSString *d = self.rawString;
    if (d) {
        return d;
    }
    return [NSString stringWithFormat:@"[Error] %@",
            self.error.localizedDescription];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@> %@", [self className], self.description];;
}

- (NSUInteger)hash {
    return [self.rawValue hash];
}

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

BOOL TRLJSONBaseIsEqual(TRLJSONBase *lhs, TRLJSONBase *rhs) {
    if (lhs.rawType == JSONTypeNumber && rhs.rawType == JSONTypeNumber) {
        return [lhs->rawNumber isEqualToNumber:rhs->rawNumber];
    } else if (lhs.rawType == JSONTypeString && rhs.rawType == JSONTypeString) {
        return [lhs->rawString isEqualToString:rhs->rawString];
    } else if (lhs.rawType == JSONTypeBool && rhs.rawType == JSONTypeBool) {
        return lhs->rawBool == rhs->rawBool;
    } else if (lhs.rawType == JSONTypeArray && rhs.rawType == JSONTypeArray) {
        return [lhs->rawArray isEqualToTRLMutableArray:rhs->rawArray];
    } else if (lhs.rawType == JSONTypeDictionary && rhs.rawType == JSONTypeDictionary) {
        return [lhs->rawDictionary isEqualToTRLMutableDictionary:rhs->rawDictionary];
    } else if (lhs.rawType == JSONTypeNull && rhs.rawType == JSONTypeNull) {
        return true;
    } else {
        return false;
    }
}

id TRLJSONBaseRawValueForType(TRLJSONBase *base, JSONType type) {
    switch (type) {
        case JSONTypeArray: return base->rawArray.array;
        case JSONTypeBool: return @(base->rawBool);
        case JSONTypeNull: return base->rawNull;
        case JSONTypeNumber: return base->rawNumber;
        case JSONTypeString: return base->rawString;
        case JSONTypeDictionary: return base->rawDictionary.dictionary;
        case JSONTypeUnknown: return nil;
    }
}

void TRLJSONBaseSetObjectForKeyedSubscript(TRLJSONBase *base, NSString *key, TRLJSONBase *object) {
    if (base.rawType == JSONTypeDictionary && object->_error == nil) {
        [base->rawDictionary setObject:object.rawValue forKeyedSubscript:key];

        NSLog(@"%@", base->rawDictionary);
    }
}

void TRLJSONBaseSetObjectForIndexedSubscript(TRLJSONBase *base, NSUInteger idx, TRLJSONBase *object) {
    if (base.rawType == JSONTypeArray) {
        if (base->rawArray.count > idx && object->_error == nil) {
            base->rawArray[idx] = object.rawValue;
        }
    }
}

void TRLJSONBaseSetRawValue(TRLJSONBase *base, id rawValue) {
    base->_error = nil;
    if ([rawValue isKindOfClass:[NSNumber class]]) {
        if (((NSNumber *)rawValue).isBool) {
            base->_rawType = JSONTypeBool;
            base->rawBool = ((NSNumber *)rawValue).boolValue;
        } else {
            base->_rawType = JSONTypeNumber;
            base->rawNumber = (NSNumber *)rawValue;
        }
    } else if ([rawValue isKindOfClass:[NSString class]]) {
        base->_rawType = JSONTypeString;
        base->rawString = (NSString *)rawValue;
    } else if ([rawValue isKindOfClass:[NSNull class]]) {
        base->_rawType = JSONTypeNull;
    } else if ([rawValue isKindOfClass:[NSArray class]]) {
        base->_rawType = JSONTypeArray;
        base->rawArray = [TRLMutableArray initWithArray:rawValue];
    } else if ([rawValue isKindOfClass:[TRLMutableArray class]]) {
        base->_rawType = JSONTypeArray;
        base->rawArray = [TRLMutableArray initWithTRLMutableArray:rawValue];
    } else if ([rawValue isKindOfClass:[NSDictionary<NSString *, id> class]]) {
        base->_rawType = JSONTypeDictionary;
        base->rawDictionary = [TRLMutableDictionary initWithDictionary:rawValue];
    } else if ([rawValue isKindOfClass:[TRLMutableDictionary class]]) {
        base->_rawType = JSONTypeDictionary;
        base->rawDictionary = (TRLMutableDictionary *)rawValue;
    } else {
        base->_rawType = JSONTypeUnknown;
        base->_error = TRLMakeError(TRLErrorJSONUnsupportedType, @"It is a unsupported type");
    }
}

NSString *_Nullable RawJSONStringForTRLJSONBase(TRLJSONBase *base, NSStringEncoding encoding, NSArray<WrittingOptions *> * opt, int depth, NSError **error ){
    if (depth < 0) {
        *error = TRLMakeError(TRLErrorJSONInvalidJSON, @"Element too deep. Increase maxObjectDepth and make sure there is no reference loop");
        return nil;
    }

    if (base->_error) {
        return base->_error.localizedDescription;
    }

    switch (base->_rawType) {
        case JSONTypeDictionary:
        {
            // Check if the code should case the nil to NSNull
            // if not then should use NSJSONSerialisation to turn
            // the code into data and then use NSJSONWritingPrettyPrinted
            // to create the raw string
            BOOL castNilToNull = [opt optionForKey:KeyCastNilToNSNull] ?
            [opt optionForKey:KeyCastNilToNSNull] : NO;
            if(!castNilToNull){
                NSJSONWritingOptions option = [opt optionForKey:KeyJsonSerialization] ? (NSJSONWritingOptions)[opt optionForKey:KeyJsonSerialization] : NSJSONWritingPrettyPrinted;
                NSError *error;
                NSData *data = [base rawDataWithOptions:option error:&error];
                if (error) {
                    return nil;
                }
                return [[NSString alloc] initWithData:data encoding:encoding];
            }

            if (![base.rawValue isKindOfClass:[NSDictionary<NSString *, id> class]]) {
                return nil;
            }

            NSError *error;
            NSDictionary<NSString *, id> *dict = (NSDictionary<NSString *, id> *)base.rawValue;
            NSArray *body = [dict.allKeys mapThrowsAndReturnError:&error :^NSArrayIndex *(NSString * key) {
                id value = dict[key];
                if (!value) {
                    return [[NSArrayIndex alloc] initWithNewObject: [NSString stringWithFormat: @"\"%@\": null", key] error:NULL];
                }

                NSError *error;
                TRLJSONBase *nestedValue = [[TRLJSONBase alloc] initWithRawValue:value];
                NSString *nestedString = RawJSONStringForTRLJSONBase(nestedValue, encoding, opt, depth, &error);
                if (error) {
                    return [[NSArrayIndex alloc] initWithNewObject:NULL error:error];
                }

                if (!nestedString) {
                    error = TRLMakeError(TRLErrorJSONInvalidJSON, @"Could not serialize nested JSON");
                    return [[NSArrayIndex alloc] initWithNewObject:NULL error:error];
                }

                NSString *str;
                if (nestedValue.rawType == JSONTypeString) {
                    NSString *value = [[nestedString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
                                       stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                    str = [NSString stringWithFormat:@"\"%@\": \"%@\"", key, value];
                    return [[NSArrayIndex alloc]initWithNewObject:str error:NULL];
                }

                str = [NSString stringWithFormat:@ "\"%@\": %@", key, nestedString];
                return [[NSArrayIndex alloc]initWithNewObject:str error:NULL];
            }];

            if (error) {
                return nil;
            }

            return [NSString stringWithFormat:@"{%@}", [body componentsJoinedByString:@","]];
        }
        case JSONTypeArray:
        {
            // Check if the code should case the nil to NSNull
            // if not then should use NSJSONSerialisation to turn
            // the code into data and then use NSJSONWritingPrettyPrinted
            // to create the raw string
            BOOL castNilToNull = [opt optionForKey:KeyCastNilToNSNull] ?
            [opt optionForKey:KeyCastNilToNSNull]:NO;
            if(!castNilToNull) {
                NSJSONWritingOptions option = [opt optionForKey:KeyJsonSerialization] ? (NSJSONWritingOptions)[opt optionForKey:KeyJsonSerialization] : NSJSONWritingPrettyPrinted;
                NSError *error;
                NSData *data = [base rawDataWithOptions:option error:&error];
                if (error) {
                    return nil;
                }
                return [[NSString alloc] initWithData:data encoding:encoding];
            }

            if (![base.rawValue isKindOfClass:[NSArray<id> class]]) {
                return nil;
            }

            NSError *error;
            NSArray *array = (NSArray *)base.rawValue;
            NSArray *body = [array mapThrowsAndReturnError:&error :^NSArrayIndex *(id value) {
                if (!value) {
                    return [[NSArrayIndex alloc] initWithNewObject:@"null" error:NULL];
                }

                NSError *error;
                TRLJSONBase *nestedValue = [[TRLJSONBase alloc] initWithRawValue:value];
                NSString *nestedString = RawJSONStringForTRLJSONBase(nestedValue, encoding, opt, depth, &error);
                if (error) {
                    return [[NSArrayIndex alloc] initWithNewObject:NULL error:error];
                }

                if (!nestedString) {
                    error = TRLMakeError(TRLErrorJSONInvalidJSON, @"Could not serialize nested JSON");
                    return [[NSArrayIndex alloc] initWithNewObject:NULL error:error];
                }

                NSString *str;
                if (nestedValue.rawType == JSONTypeString) {
                    NSString *value = [[nestedString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
                                       stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                    str = [NSString stringWithFormat:@"\"%@\"", value];
                    return [[NSArrayIndex alloc]initWithNewObject:str error:NULL];
                }
                return [[NSArrayIndex alloc]initWithNewObject:nestedString error:NULL];
            }];

            if (error) {
                return nil;
            }

            return [NSString stringWithFormat:@"[%@]", [body componentsJoinedByString:@","]];
        }
        case JSONTypeString: return base->rawString;
        case JSONTypeNumber: return base->rawNumber.stringValue;
        case JSONTypeBool: return base->rawBool ? @"true" : @"false";
        case JSONTypeNull: return @"null";
        default: return nil;
    }
}

@end
