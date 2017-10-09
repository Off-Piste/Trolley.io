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

static TRLAnalyticsQueue *aQueue;

@implementation TRLAnalyticsQueue {
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
        _queue = [[NSMutableOrderedSet alloc] init];
        _defaults = [TRLDefaultsManager managerForKey:kTRLQueueStorageKey];
    }
    return self;
}

#pragma mark Set Confomaties

- (void)addObject:(id)object {
    [_queue addObject:object];
}

- (void)removeObject {
    [_queue removeObjectAtIndex:0];
}

- (NSUInteger)count {
    return _queue.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id  _Nullable __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    return [_queue countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark Queue Parts

- (TRLJSON *)jsonForObject {
    NSAssert(_queue.count != 0, @"Cannot get an object from a empty queue");
    return [[_queue firstObject] json];
}

- (void)retrieveFromStorage {
    NSError *error;
    NSMutableOrderedSet<TRLAnalyticsObject *> *queue = [_defaults retriveObject:&error];

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

    _queue = queue;
}

- (void)pushToStorage {
    if (_queue.count == 0) {
        _queue = nil;
    }

    NSError *error;
    [_defaults setObject:_queue ? _queue : [[NSMutableOrderedSet alloc] init] error:&error];

    if (error) {
        TRLErrorLogger(TRLLoggerServiceAnalytics, "Error: %@", error.localizedDescription);
        return;
    }

    [_queue removeAllObjects];
}



@end
