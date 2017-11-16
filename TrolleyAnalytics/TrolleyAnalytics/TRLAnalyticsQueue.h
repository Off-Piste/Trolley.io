//
//  TRLAnalyticsQueue.h
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRLJSON;
@class TRLAnalyticsObject;

@interface TRLAnalyticsQueue : NSObject <NSFastEnumeration>

/**
 <#Description#>

 @return <#return value description#>
 */
+ (instancetype)defaultQueue;

/**
 <#Description#>

 @param object <#object description#>
 */
- (void)addObject:(TRLAnalyticsObject *)object;

/**
 <#Description#>
 */
- (void)removeObject;

/**
 <#Description#>

 @param block <#block description#>
 */
- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(TRLAnalyticsObject *obj, NSUInteger idx, BOOL *stop))block;

/**
 <#Description#>

 @param index <#index description#>
 */
- (void)removeObjectInIndexes:(NSIndexSet *)index;

/**
 <#Description#>
 */
- (void)retrieveFromStorage;

/**
 <#Description#>
 */
- (void)pushToStorage;

@end
