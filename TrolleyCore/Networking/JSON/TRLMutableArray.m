//
//  TRLMutableArray.m
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 06.09.17.
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

#import "TRLMutableArray.h"

#import "NSArray+Map.h"

@implementation TRLMutableArray {
    /// The mutable dictionary.
    NSMutableArray *_objects;

    /// Serial synchronization queue. All reads should use dispatch_sync, while writes use
    /// dispatch_async.
    dispatch_queue_t _queue;
}

+ (instancetype)initWithArray:(NSArray *)array {
    return [TRLMutableArray initWithMutableArray:array.mutableCopy];
}

+ (instancetype)initWithMutableArray:(NSMutableArray *)array {
    return [[TRLMutableArray alloc] initWithMutableArray:array];
}

+ (instancetype)initWithTRLMutableArray:(TRLMutableArray *)array {
    return [TRLMutableArray initWithMutableArray:array->_objects];
}

- (instancetype)initWithMutableArray:(NSMutableArray *)array {
    if (self = [super init]) {
        self->_objects = array.mutableCopy;
        _queue = dispatch_queue_create("TRLMutableArray", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self->_objects = [[NSMutableArray alloc] init];
        _queue = dispatch_queue_create("TRLMutableArray", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    dispatch_async(_queue, ^{
        _objects[idx] = obj;
    });
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    __block id obj;
    dispatch_sync(_queue, ^{
        obj = _objects[idx];
    });
    return obj;
}

- (void)setObject:(id)object {
    dispatch_async(_queue, ^{
        [_objects addObject:object];
    });
}

- (void)removeAll {
    [_objects removeAllObjects];
}

- (id)objectAtIndex:(NSUInteger)idx {
    __block id object;
    dispatch_sync(_queue, ^{
        object = _objects[idx];
    });
    return object;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    dispatch_async(_queue, ^{
        [_objects enumerateObjectsUsingBlock:block];
    });
}

- (instancetype)map:(id  _Nonnull (^)(id _Nonnull, NSUInteger))block {
    __block NSArray *array;
    dispatch_sync(_queue, ^{
        array = [_objects map:block];
    });
    return [TRLMutableArray initWithArray:array];
}

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(_queue, ^{
        count = _objects.count;
    });
    return count;
}

- (NSArray *)array {
    __block NSArray *arr;
    dispatch_sync(_queue, ^{
        arr = [_objects copy];
    });
    return arr;
}

- (BOOL)isEqualToArray:(NSArray *)arg1 {
    return [_objects isEqualToArray:arg1];
}

- (BOOL)isEqualToTRLMutableArray:(TRLMutableArray *)arg1 {
    return [_objects isEqualToArray:arg1->_objects];
}

@end
