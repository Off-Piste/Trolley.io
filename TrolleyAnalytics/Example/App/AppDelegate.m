//
//  AppDelegate.m
//  App
//
//  Created by Harry Wright on 10.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import "AppDelegate.h"

@import Trolley;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [Trolley setLoggingLevel:TRLLoggerLevelDebug];
    [Trolley open];

    return YES;
}

@end
