/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@import Foundation;

/// This is taken from Firebase/Core as a workaround for:
/// https://stackoverflow.com/questions/39495680/objective-c-category-for-nsmutabledictionary-not-being-respected-in-ios10

/// A mutable dictionary that provides atomic accessor and mutators.
@interface TRLMutableDictionary<KeyType, ObjectType: id> : NSObject

///
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;

///
+ (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary;

///
+ (instancetype)initWithTRLMutableDictionary:(TRLMutableDictionary *)dictionary;

/// Returns an object given a key in the dictionary or nil if not found.
- (ObjectType)objectForKey:(KeyType)key;

/// Updates the object given its key or adds it to the dictionary if it is not in the dictionary.
- (void)setObject:(ObjectType)object forKey:(KeyType)key;

/// Removes the object given its session ID from the dictionary.
- (void)removeObjectForKey:(id)key;

/// Removes all objects.
- (void)removeAllObjects;

/// Returns the number of current objects in the dictionary.
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger count;

/// Returns an object given a key in the dictionary or nil if not found.
- (ObjectType)objectForKeyedSubscript:(KeyType)key;

/// Updates the object given its key or adds it to the dictionary if it is not in the dictionary.
- (void)setObject:(ObjectType)obj forKeyedSubscript:(KeyType)key;

/// Returns the immutable dictionary.
- (NSDictionary *)dictionary;

///
- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(KeyType key, ObjectType obj, BOOL *stop))block;

///
- (BOOL)isEqualToDictionary:(NSDictionary *)arg1;

///
- (BOOL)isEqualToTRLMutableDictionary:(TRLMutableDictionary *)arg1;

@end
