//
//  TrolleyAnalytics.m
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import "TrolleyAnalytics.h"
#import "TRLAnalyticsQueue.h"
#import "TRLAnalyticsConstants.h"

#import <TrolleyAnalytics/TrolleyAnalytics-Swift.h>

@import TrolleyCore;

static TRLAnalytics *anAnalytics;

@implementation TRLAnalytics {
    NSNotificationCenter *_center;
    TRLAnalyticsQueue *_queue;
    TRLNetworkManager *_manager;
    BOOL serverIsConnected;
}

+ (TRLAnalytics *)shared {
    if (anAnalytics) {
        return anAnalytics;
    }

    @synchronized(self) {
        anAnalytics = [[TRLAnalytics alloc] init];
        return anAnalytics;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _center = [NSNotificationCenter defaultCenter];
        _queue = [TRLAnalyticsQueue defaultQueue];
        [self waitForNotifications];
    }
    return self;
}

- (void)waitForNotifications {
    [_center addObserver:self
                selector:@selector(startUpObserved:)
                    name:TRLTrolleyStartingUpNotification
                  object:nil];

    [_center addObserver:self
                selector:@selector(serverIsConnected:)
                    name:TRLNetworkConnectedNotification
                  object:nil];

    [_center addObserver:self
                selector:@selector(serverIsDisconnected:)
                    name:TRLNetworkDisconnectedNotification
                  object:nil];

}

- (void)startUpObserved:(NSNotification *)note {
    TRLDebugLogger(TRLLoggerServiceAnalytics, "Notification [%@] has been observed: %@", TRLTrolleyStartingUpNotification, note);

    // Validate that it is a valid start up and not sent by something else
}

- (void)serverIsConnected:(NSNotification *)note {
    serverIsConnected = YES;
    [_queue retrieveFromStorage];

    _manager = trl_get_network_manager();
    for (TRLAnalyticsObject *obj in _queue) {
        if (serverIsConnected) {
            trl_network_manager_send(_manager, [obj.json dictionaryObject], YES);
            [_queue removeObject];
        } else {
            break;
        }
    }
}

- (void)serverIsDisconnected:(NSNotification *)note {
    serverIsConnected = NO;
    [_queue pushToStorage];


    _manager = nil;
}

@end
