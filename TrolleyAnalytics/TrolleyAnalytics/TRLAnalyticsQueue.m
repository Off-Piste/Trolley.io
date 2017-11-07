//
//  TRLAnalyticsQueue.m
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

@import TrolleyCore;

#warning FIXME

#import "TRLAnalyticsQueue.h"
#import "TRLAnalyticsConstants.h"

#import <TrolleyAnalytics/TrolleyAnalytics-Swift.h>

#define TRLAnalyticsObjectSet NSMutableOrderedSet<TRLAnalyticsObject *>*

static TRLAnalyticsQueue *aQueue;

@implementation TRLAnalyticsQueue {
    BOOL isStored;
    NSMutableOrderedSet<TRLAnalyticsObject *> *_queue;
    TRLDefaultsManager *_defaults;
}

#pragma mark LifeCycle

+ (instancetype)defaultQueue {
    if (aQueue) {
        return aQueue;
    }

    @synchronized(self) {
        aQueue = [[TRLAnalyticsQueue alloc] init];
        return aQueue;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        isStored = YES;
        _queue = [[NSMutableOrderedSet alloc] init];
        _defaults = [TRLDefaultsManager managerForKey:kTRLQueueStorageKey];
        [_defaults clearObject];
    }
    return self;
}

#pragma mark Set Confomaties

- (void)addObject:(id)object {
    if (isStored) {
        [self addObjectWhileInStorage:object];
    } else {
        [_queue addObject:object];
    }
}

- (void)removeObject {
    if (isStored) {
        [self removeObjectWhileInStorage];
    } else {
        [_queue removeObjectAtIndex:0];
    }
}

- (void)addObjectWhileInStorage:(TRLAnalyticsObject *)object {
    [self retrieveFromStorage];
    [_queue addObject:object];
    [self pushToStorage];
}

- (void)removeObjectWhileInStorage {
    [self retrieveFromStorage];
    [_queue removeObjectAtIndex:0];
    [self pushToStorage];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id  _Nullable __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    return [_queue countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark Queue Parts

- (void)retrieveFromStorage {
    // Check to see if the items are being stored
    NSAssert(isStored, @"Cannot retrieve from storage if the objects are not there");

    // Retrieve the queue
    NSError *error;
    TRLAnalyticsObjectSet queue = [_defaults retriveObject:&error];;

    // If the code is returning TRLErrorDefaultsManagerNilReturnValue that should mean
    // the queue is empty, if so create the queue with an empty set
    if (error && error.code != TRLErrorDefaultsManagerNilReturnValue) {
        TRLErrorLogger(TRLLoggerServiceAnalytics, "Error: %@", error.localizedDescription);
        return;
    } else if (error.code == TRLErrorDefaultsManagerNilReturnValue) {
        queue = [[NSMutableOrderedSet alloc] init];
    }

    if (_queue.count != 0) {
        [_queue removeAllObjects];
    }

    // Once the errors have been handled && the live queue has been emptied
    // set the new queue, delete the queue in storage and set isStored = NO;
    _queue = queue;
    [_defaults clearObject];
    isStored = NO;
}

- (void)pushToStorage {
    // Should never hit an error so if it does its a bug
    NSError *error;
    [_defaults setObject:_queue?: [[NSMutableOrderedSet alloc] init] error:&error];
    assert(error == nil);

    [_queue removeAllObjects];
    isStored = YES;
}



@end
