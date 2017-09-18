// Copyright 2017 Google
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "TRLMutableDictionary.h"

@implementation TRLMutableDictionary {
  /// The mutable dictionary.
  NSMutableDictionary *_objects;

  /// Serial synchronization queue. All reads should use dispatch_sync, while writes use
  /// dispatch_async.
  dispatch_queue_t _queue;
}

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    return [TRLMutableDictionary initWithMutableDictionary:dictionary.mutableCopy];
}

+ (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary {
    return [[TRLMutableDictionary alloc] initWithDictionary:dictionary];
}

+ (instancetype)initWithTRLMutableDictionary:(TRLMutableDictionary *)dictionary {
    return [TRLMutableDictionary initWithMutableDictionary:dictionary.dictionary.mutableCopy];
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)newDictionary {
    if (self = [super init]) {
        self->_objects = newDictionary;
        self->_queue = dispatch_queue_create("TRLMutableDictionary", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)init {
  self = [super init];

  if (self) {
    _objects = [[NSMutableDictionary alloc] init];
    _queue = dispatch_queue_create("TRLMutableDictionary", DISPATCH_QUEUE_SERIAL);
  }

  return self;
}

- (NSString *)description {
  __block NSString *description;
  dispatch_sync(_queue, ^{
    description = _objects.description;
  });
  return description;
}

- (id)objectForKey:(id)key {
  __block id object;
  dispatch_sync(_queue, ^{
    object = _objects[key];
  });
  return object;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
  dispatch_async(_queue, ^{
    _objects[key] = object;
  });
}

- (void)removeObjectForKey:(id)key {
  dispatch_async(_queue, ^{
    [_objects removeObjectForKey:key];
  });
}

- (void)removeAllObjects {
  dispatch_async(_queue, ^{
    [_objects removeAllObjects];
  });
}

- (NSUInteger)count {
  __block NSUInteger count;
  dispatch_sync(_queue, ^{
    count = _objects.count;
  });
  return count;
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
  // The method this calls is already synchronized.
  return self[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
  // The method this calls is already synchronized.
  self[key] = obj;
}

- (NSDictionary *)dictionary {
  __block NSDictionary *dictionary;
  dispatch_sync(_queue, ^{
    dictionary = [_objects copy];
  });
  return dictionary;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id, id, BOOL *))block {
    dispatch_async(_queue, ^{
        [_objects enumerateKeysAndObjectsUsingBlock:block];
    });
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [self isEqualToDictionary:(NSDictionary *)object];
    } else if ([object isKindOfClass:[TRLMutableDictionary class]]) {
        return [self isEqualToTRLMutableDictionary:(TRLMutableDictionary *)object];
    }
    return [super isEqual:object];
}

- (BOOL)isEqualToDictionary:(NSDictionary *)arg1 {
    return [_objects isEqualToDictionary:arg1];
}

- (BOOL)isEqualToTRLMutableDictionary:(TRLMutableDictionary *)arg1 {
    return [self isEqualToDictionary:arg1->_objects];
}

@end
