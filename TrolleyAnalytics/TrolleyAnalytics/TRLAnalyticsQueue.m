//
//  TRLAnalyticsQueue.m
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

@import TrolleyCore;

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
    return [self initWithQueue:[[NSMutableOrderedSet alloc] init]];
}

- (instancetype)initWithQueue:(NSMutableOrderedSet *)queue {
    if (self = [super init]) {
        isStored = YES;
        _queue = queue;
        _defaults = [TRLDefaultsManager managerForKey:kTRLQueueStorageKey];
        [_defaults clearObject];
    }
    return self;
}

#pragma mark Set Confomaties

- (void)enumerateObjectsUsingBlock:(void (^)(TRLAnalyticsObject *, NSUInteger, BOOL *))block {
    [_queue enumerateObjectsUsingBlock:block];
}

- (id)copy {
    return [[TRLAnalyticsQueue alloc] initWithQueue:_queue];
}

- (void)addObject:(id)object {
    if (isStored) {
        [self addObjectWhileInStorage:object];
    } else {
        [_queue addObject:object];
    }
}

- (void)removeObject {
    if (isStored) {
        [self removeObjectWhileInStorageForIndex:0];
    } else {
        [_queue removeObjectAtIndex:0];
    }
}

- (void)removeObjectInIndexes:(NSIndexSet *)index {
    if (!isStored) {
        [_queue removeObjectsAtIndexes:index];
    } else {
        [self removeObjectAtIndexesWhileInStorage:index];
    }
}

- (void)removeObjectAtIndex:(NSInteger)index {
    if (isStored) {
        [self removeObjectWhileInStorageForIndex:index];
    } else {
        [_queue removeObjectAtIndex:index];
    }
}

- (void)addObjectWhileInStorage:(TRLAnalyticsObject *)object {
    [self retrieveFromStorage];
    [_queue addObject:object];
    [self pushToStorage];
}

- (void)removeObjectWhileInStorageForIndex:(NSInteger)index {
    [self retrieveFromStorage];
    [_queue removeObjectAtIndex:index];
    [self pushToStorage];
}

- (void)removeObjectAtIndexesWhileInStorage:(NSIndexSet *)index {
    [self retrieveFromStorage];
    [_queue removeObjectsAtIndexes:index];
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
    if (!isStored) { return; }

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
